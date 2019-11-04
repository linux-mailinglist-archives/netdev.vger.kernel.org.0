Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02823EE2D9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 15:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfKDOtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 09:49:15 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37233 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKDOtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 09:49:15 -0500
Received: by mail-qk1-f194.google.com with SMTP id e187so5105355qkf.4;
        Mon, 04 Nov 2019 06:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yg35CIgMCDjht+ZPU7pxGiVxYKNbmDF87GWEVQqBk4g=;
        b=EeRWCft8TXJWTU/w0UoFt0p+unRSYZR/wh8VxMzC4je4nmw3swP8V2nZuWpcQ4CF6q
         RYxxjGsIzl+JI7qoTeneH3FYzSpbe0/uRRyrS43MkSOhZ6Th4O9QXGMKKh31MCfGDcxq
         fkxVIdbclEoDHtEhIUhCO/xoG46dXebq6u12F/0fUEbQRVHd944YP/rp47HkvFOAQ2ei
         za1uXKE74aK6Fi98SE0CgFuJBncNRnttzAhEMmQ6PA5GVWZLkyQk65M8+44GcT1ND3Yl
         ctOLE3aKV8FGgeai9E3a+3qFYhKq9Q42ddAuqY+JIA8MA1Hu34pcbbb9ik2XrgEYCrZo
         R2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yg35CIgMCDjht+ZPU7pxGiVxYKNbmDF87GWEVQqBk4g=;
        b=ZTm3lLrZG8Pj1E7Sl+KRCQWOYxCxufR/DcthmxJAntyagC8NAQDArB5Bh2PDwKh+mZ
         Bfo9slr7S4o49AvqeEDzeQzzHAg3AKW0dGugj6XoFAVvwhAo1yfv9+MCIxus/aUkt+wB
         4/bQMK1EIdbJqVRdPfYjY3WlvX/brXR/I9fFXwS0N9mzz3/UntKlAIAtmgLeopXlv8zG
         TDG02WjBirZSRWFop8sW5gyzfDAdCODSMC8YJh7sakDnqtonVvcAzPfXtXvXhay4rxsK
         A0v8/Cun1ME79VoeUqkUqJVolji66dDBrQFQGaTNAYWRVDTGDX8VvZKyiKQOOU3/rPoC
         OvwA==
X-Gm-Message-State: APjAAAVICNOHOb7uxy2oG1ctObUe85YyoC1HoutsvDAcpIAjMLmYYAXg
        1PI+dIh0gs7qHgg9U1hWoRBPYtreCkDDtQ==
X-Google-Smtp-Source: APXvYqyIN2+D81NcwxppEZcFi3I9pVfC97qSGyKleagUeGT9LV4bx6w2VWrHO+YvU8qi5LJAI0J7CA==
X-Received: by 2002:ae9:e851:: with SMTP id a78mr17447837qkg.312.1572878953090;
        Mon, 04 Nov 2019 06:49:13 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.201])
        by smtp.gmail.com with ESMTPSA id l50sm4114604qtc.7.2019.11.04.06.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 06:49:12 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id BC2ECC16E7; Mon,  4 Nov 2019 11:49:09 -0300 (-03)
Date:   Mon, 4 Nov 2019 11:49:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Wei Zhao <wallyzhao@gmail.com>
Cc:     kernel test robot <rong.a.chen@intel.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com,
        lkp@lists.01.org
Subject: Re: [sctp] 327fecdaf3: BUG:kernel_NULL_pointer_dereference,address
Message-ID: <20191104144909.GA15842@localhost.localdomain>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
 <20191104084635.GM29418@shao2-debian>
 <20191104132508.GA53856@localhost.localdomain>
 <CAFRmqq6vNg5sBYp7voT4SoVR+i+L8fDqUUZOF68cRdcKkQcZmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRmqq6vNg5sBYp7voT4SoVR+i+L8fDqUUZOF68cRdcKkQcZmw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 10:14:00PM +0800, Wei Zhao wrote:
> On 11/4/19, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Mon, Nov 04, 2019 at 04:46:35PM +0800, kernel test robot wrote:
> >> [   35.312661] BUG: kernel NULL pointer dereference, address:
> >> 00000000000005d8
> >> [   35.316225] #PF: supervisor read access in kernel mode
> >> [   35.319178] #PF: error_code(0x0000) - not-present page
> >> [   35.322078] PGD 800000021b569067 P4D 800000021b569067 PUD 21b688067 PMD
> >> 0
> >> [   35.325629] Oops: 0000 [#1] SMP PTI
> >> [   35.327965] CPU: 0 PID: 3148 Comm: trinity-c5 Not tainted
> >> 5.4.0-rc3-01107-g327fecdaf39ab #12
> >> [   35.332863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> >> 1.10.2-1 04/01/2014
> >> [   35.337932] RIP: 0010:sctp_packet_transmit+0x767/0x822
> >
> > Right, as asoc can be NULL by then. (per the check on it a few lines
> > before the change here).
> 
> Yes, apologize for missing the NULL check (Actually I realized some
> further check is need to correctly identify the first in flight
> packet, as outstanding_bytes has already been increased by this first
> in flight packet itself before getting into sctp_packet_transmit).
> 
> Anyway, I think I do not need further action, as the patch is anyway
> not going to be merged, the 0day robot picks up the patch from the
> mail list directly instead of git repo, right?

That's my understanding as well. I double checked and the patch wasn't
applied by Dave, so we're good.

Thanks,
Marcelo
