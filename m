Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE88373191
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbfGXOZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:25:17 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37622 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfGXOZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 10:25:17 -0400
Received: by mail-qk1-f194.google.com with SMTP id d15so33854187qkl.4;
        Wed, 24 Jul 2019 07:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JucAj4L4ERbLHKaxczBpVI8Yq6S7ncxo8NCKhGzQdOM=;
        b=ouGkK0xNUIsus3JvZMzu0yqWevc/3D9xYgiaDQ/xlGsSznX5qxer2kCE/lS8Zs6uGK
         DNno9yI1QkGZSLuVVhjv6qe3hARZy6uCVR8R9trPJWg3wBEXCDKpxaVltFclu3SmEGf6
         CU/N/UAdz2x7VaFJEGvAYHjwDoC9DD1rtkWCx4lSHVK85Wih+JXkdlPkMyooElqKETnv
         xOKK2v50DzSwJMVrW/1KWDVigo9cKWu1LWJglgenp92rdU4aFl6jwuPEaFbpTAV8YwVD
         keN/5pHuMcBoiQVS0R8z2BjoeEhgWSEyGQCl2Pyij/HA+R5TkemNATpcQVceXU+Xzlaw
         jM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JucAj4L4ERbLHKaxczBpVI8Yq6S7ncxo8NCKhGzQdOM=;
        b=ACk/E87xi+UWl1qdfyjiQUNRbaZmNxbNbNsaslrchGY581G/vB7H1PhVmRKlO43uMH
         nLBYwViT46afLFxb+Sz/DrXHT81U0QMRDQk7EUAiQssGF3QBW/axfnRbAd5cuHdp5z63
         oaatsD2T6yb/aYyKXA1bD7i3YcHhmS+HRkHX/9qPX7b10VE5h94GuDVkIWXRD0Egg74t
         ce9UtgPhLvRsOtBSVHIOt4WYPA5xlXjs3niEnRZksDJ66+UgR0T0Qhn3J/P9raOPHNZt
         cFEw+20LvpHJpx9WwxQCjw/99/Ai01sE0A0/aEVVHlO4IaedSm3Rvv9fewMitewA1eQt
         y91g==
X-Gm-Message-State: APjAAAWU6NvJeZm+g9NXcW63SkgY1UhkV5CBD7rAeJUOAAbnC1OrO1m4
        bRtNE2LD6EzgzzSVzqw0bII=
X-Google-Smtp-Source: APXvYqyNJSC9XNTSChs30bNAW5VjsflpRw66jCyxm+M64jfJQO//XE9LzEthmfxYt5cZvLZWdOpf7A==
X-Received: by 2002:a05:620a:710:: with SMTP id 16mr13832752qkc.382.1563978316045;
        Wed, 24 Jul 2019 07:25:16 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.45])
        by smtp.gmail.com with ESMTPSA id x206sm21661792qkb.127.2019.07.24.07.25.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 07:25:15 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D8E20C0AAD; Wed, 24 Jul 2019 11:25:12 -0300 (-03)
Date:   Wed, 24 Jul 2019 11:25:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 0/4] sctp: clean up __sctp_connect function
Message-ID: <20190724142512.GG6204@localhost.localdomain>
References: <cover.1563817029.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 01:37:56AM +0800, Xin Long wrote:
> This patchset is to factor out some common code for
> sctp_sendmsg_new_asoc() and __sctp_connect() into 2
> new functioins.
> 
> Xin Long (4):
>   sctp: check addr_size with sa_family_t size in
>     __sctp_setsockopt_connectx
>   sctp: clean up __sctp_connect
>   sctp: factor out sctp_connect_new_asoc
>   sctp: factor out sctp_connect_add_peer

Nice cleanup! These patches LGTM. Hopefully for Neil as well.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
