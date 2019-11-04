Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB06EF11D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfKDXSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 18:18:55 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:35728 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbfKDXSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 18:18:55 -0500
Received: by mail-lj1-f174.google.com with SMTP id r7so10893327ljg.2
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 15:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=DePzYP5BJ5eVATHDTLUyBFhrUFGBaRz2oxQFphfMMfU=;
        b=t3tLdFK9YpD6nQHjFjMzRb7Js+RYu5oUTgo0cnT2CdVaTeNve2XIwytTcce7HLQIDI
         IZcmxFVPpAalkrYAkUl7HNmL930CVDPALl7Gg7xrTk7bWK7w2gO/6z88aUbyHA73dS7W
         C1iBEQczLSL1LwL9FsfOgs+XWaYdBL4Bt3oB+9YCRY2LJIJsW8PXjPxGAyBzkQ3DSyuX
         hYZ9PC71ir5dcN+9W7cmVkXUeltFkogejNPMakxlNharNH9rmh2JawMjSQY0NjJtqntN
         Eywaajr1P8HcRRyrqAOk0NG7FsqAB0R1Ad8/OXJhDKk4dUHBGH/ezPF1i+yON2iXvJLI
         Duvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DePzYP5BJ5eVATHDTLUyBFhrUFGBaRz2oxQFphfMMfU=;
        b=qz9mQ9oMXLFBNDCowoT2fEPA7VvcYodNdL1U6VRKuL8Mo7xijqtxfHDR/92NUlkA2o
         Tf1d9kaq6W9xhpjk65niff/RquQDt0FSqV5+SMcysYYNFEBfc9dcs8LNT5hO/yZhTTZR
         n4YNIA/wAy8WpX6FdcBlc3oXHzMw+JYGnP3pVu1Mt2rquiL+oj1fEorcu0+WIQftyk52
         Ofx3otxzV0UOxR7Nj1dWu1cTy9O4tnsEaVS8oqkbeHYZAskRb1/esdG7wp1gJsFnk0mG
         2Kc/bdUWKdA3UTAISXZRLjQEg2+sQSEUiOoVl6v+yiDXgU5zlgklnITZTERnN8pf7jWh
         u0Xw==
X-Gm-Message-State: APjAAAU358wUgNYo4phGVcHOeen7IWbI8k5NB+3r2ceJRGpuMLZOVwnj
        dg8cs33PgG2yPQGZMIXjRQFLPQ==
X-Google-Smtp-Source: APXvYqwpBXcxUdf2n0a+CbkVKRf5e/4THIkS9YBFzqytpXToi7cLyk5cPm/sjVsIANiWwSselWDiWw==
X-Received: by 2002:a2e:2a05:: with SMTP id q5mr12524275ljq.170.1572909533593;
        Mon, 04 Nov 2019 15:18:53 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y6sm8065826lfj.75.2019.11.04.15.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 15:18:53 -0800 (PST)
Date:   Mon, 4 Nov 2019 15:18:46 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 0/7][pull request] 10GbE Intel Wired LAN Driver
 Updates 2019-11-04
Message-ID: <20191104151846.37200472@cakuba.netronome.com>
In-Reply-To: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
References: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Nov 2019 13:23:41 -0800, Jeff Kirsher wrote:
> v2: Fixed up commit id references in patch 5's description to align with
>     how commit id's should be referenced.

Thanks, LGTM!
