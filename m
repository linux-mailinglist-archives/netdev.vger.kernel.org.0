Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B688C3E1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfHMVnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:43:15 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:37510 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfHMVnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:43:14 -0400
Received: by mail-qt1-f176.google.com with SMTP id y26so108011587qto.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qiSTJ6qFzTdxjQSVFC4kjVsmnDq/IOy+A+P7ugvnRw8=;
        b=lfMiALlKBeZ6L9BRpyNGOQk0nJIUBlrGXNd0Irq38vnTk15Faf742wNtBNnwwGANpP
         lN9oXfYny5uOkctlEqh0uKdI2PVu4oPOLW6Mfe/9TlcQZrWdsJGthZXNcYiCWdJcZiGQ
         GZMutEknWofp6Ecwq99FEqkNHfREbu2ENnUkpA24uQyjhpD24LrfvQlyj6YRyhNdSmtv
         LBdUPtt/TwMUn1vazsJ0Tt8T6iqv+v0WJHKKJV6r+HBmjxwgmyEHgpuvBZn77LsfAUD5
         ttZPmwoG58yJeBVxEZIMJedWyPAWPNeZtiqUNBC2WNbSWw1yWo9JLTxxVGgk2CAz7O9W
         Tg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qiSTJ6qFzTdxjQSVFC4kjVsmnDq/IOy+A+P7ugvnRw8=;
        b=Ha/rh5hevdxNlrpjPPDYRTYZb18a494QeZrg5HxFQQFQCuJs2yVQw5VOJp9EgCfhS1
         dw7sJ9LlFWoS4b2pCLNu5fesqNWIoJS45SShIvqUXfqjB2rtk/mZF7HOUCTmGwGyVzGw
         qc8ZWwdGht231UiBkZbzZWcADSfWraD8P7NZ4oW5vtOYyWcm1av8RV3/G4kTt0t0XARj
         cbUjK2KX3QYd/XOh48+COdvhThK1H3YPGjcQreyhNqlmrrGFqUEKBXb14GL7rpbeMINP
         KtxfGq1+aQZ+8Iu+RZ2YuMEyxDVRPlm5W3r++Gjm79pqO+FuMyqlCi13qdIHPhDJ2KKK
         hTZA==
X-Gm-Message-State: APjAAAWiZ0N9jyb+Cm1EPJlO+V9l7rGEQPpjgWxBURs42M2EuALBU7vV
        yE4EZ4SgGKThmxYTEa+1y9nAzw==
X-Google-Smtp-Source: APXvYqx93pv/MUZASLsrsMVbJrEim19okHHmJuYpM1Pg+VjKU0i6f6mfBjP4hzy7I1A4K5h1habiFA==
X-Received: by 2002:a0c:e588:: with SMTP id t8mr257094qvm.179.1565732593875;
        Tue, 13 Aug 2019 14:43:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m27sm54906110qtu.31.2019.08.13.14.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 14:43:13 -0700 (PDT)
Date:   Tue, 13 Aug 2019 14:43:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [v5,0/4] tools: bpftool: add net attach/detach command to
 attach XDP prog
Message-ID: <20190813144303.10da8ff0@cakuba.netronome.com>
In-Reply-To: <20190813024621.29886-1-danieltimlee@gmail.com>
References: <20190813024621.29886-1-danieltimlee@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 11:46:17 +0900, Daniel T. Lee wrote:
> Currently, bpftool net only supports dumping progs attached on the
> interface. To attach XDP prog on interface, user must use other tool
> (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> can attach/detach XDP prog on interface.
> 
>     # bpftool prog
>         16: xdp  name xdp_prog1  tag 539ec6ce11b52f98  gpl
>         loaded_at 2019-08-07T08:30:17+0900  uid 0
>         ...
>         20: xdp  name xdp_fwd_prog  tag b9cb69f121e4a274  gpl
>         loaded_at 2019-08-07T08:30:17+0900  uid 0
> 
>     # bpftool net attach xdpdrv id 16 dev enp6s0np0
>     # bpftool net
>     xdp:
>         enp6s0np0(4) driver id 16
> 
>     # bpftool net attach xdpdrv id 20 dev enp6s0np0 overwrite
>     # bpftool net
>     xdp:
>         enp6s0np0(4) driver id 20
> 
>     # bpftool net detach xdpdrv dev enp6s0np0
>     # bpftool net
>     xdp:
> 
> 
> While this patch only contains support for XDP, through `net
> attach/detach`, bpftool can further support other prog attach types.
> 
> XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.
> 
> ---
> Changes in v5:
>   - fix wrong error message, from errno to err with do_attach/detach

The inconsistency in libbpf's error reporting is generally troubling,
but a problem of this set, so:

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

In the future please keep review tags if you have only made minor
changes to the code.
