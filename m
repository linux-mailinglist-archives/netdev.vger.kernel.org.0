Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8720950E4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 00:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfHSWhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 18:37:51 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39317 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbfHSWhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 18:37:50 -0400
Received: by mail-qk1-f195.google.com with SMTP id 125so2891094qkl.6
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 15:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rsagY98pY3y6P0r4oJuEyk/CtDLJ+v8VBbs+1ATcMes=;
        b=pA5NkowDQ5sq9RA3z0tdahrFNXl+dfJGk9N66l2fvNKchiHZvUSkHGZ7h/Yh2732yN
         yzS75fIomcfJFlJ43MOV759PKSj22Z+ftqvzbDqfIXvyBp8AUcgl87jUX6Q3yQ7jUMrU
         cv0DcTJGDS3ypjuPMs6xn+PIjz/RigfsLsnlDZICreCmYzS/AjZtsQD9nduFkNhHRsit
         M7S11k4Hz58CBMxaYZ1gVgKM/XOVnZJbnqREW16/PC2hLbgSkVeRp8Rp53O7BQ64Lxch
         jpqlFJ+LypHmVKgmV+EtwOipnlmyYVrkQi5F0THYGR+2CoFONkjYDloHOkx+dE6FC2x1
         Ur3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rsagY98pY3y6P0r4oJuEyk/CtDLJ+v8VBbs+1ATcMes=;
        b=pAYd7dDUiSRrZ7X6JqCZcwWIddGHqGTaytR+v7xomAbhSEXM7KKH2NinU1smyDVLrB
         w6OzTDJzkopB/CVF2vV41SG+296JpzVzvETXLNbtihyOG9+GxYOFlWKdz0sybgGqJ7rB
         /YVy+RCk5WJKdOlvt2ySXgbZiC56fzZ/4LJPTxh996gpYlETa1/Wv99d9YNnLEv0/Y/Z
         /kthq54N86xnhYgZXNGZvL2NC2wg9IUL9cV7FIQTzi1itf224MYtua5WAjta/7Tkxab0
         2sbk92Y5Z4MHGy4iPKyDR9wefousVU2WBeCqGl7nU52FumkUYodClc3njzmTdsCouDx6
         uDPw==
X-Gm-Message-State: APjAAAWhgCphKT2vTzMIAloSatCvraDWsN+SUincmTDQLUwzfFVE8j+U
        W3x0SNnULhoHbs5ZBOyYkHNW9Q==
X-Google-Smtp-Source: APXvYqxZi9h9aRIS+EXau57hZDU/wx9fF+xgZ0qy+6NMAZ+eniAdhhoqfD3KytvlBByc7Q72rfNzIw==
X-Received: by 2002:a37:a358:: with SMTP id m85mr23592048qke.190.1566254269969;
        Mon, 19 Aug 2019 15:37:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm7373384qtq.73.2019.08.19.15.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 15:37:49 -0700 (PDT)
Date:   Mon, 19 Aug 2019 15:37:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+70ab6a1f8151888c4ea0@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING: ODEBUG bug in tls_sw_free_resources_tx
Message-ID: <20190819153743.33eea0b2@cakuba.netronome.com>
In-Reply-To: <00000000000062c5c3057a095d25@google.com>
References: <00000000000062c5c3057a095d25@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 06 Nov 2018 17:52:03 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7c6c54b505b8 Merge branch 'i2c/for-next' of git://git.kern..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1276246d400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=136ed5b316dbf1d8
> dashboard link: https://syzkaller.appspot.com/bug?extid=70ab6a1f8151888c4ea0
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+70ab6a1f8151888c4ea0@syzkaller.appspotmail.com

This was most likely fixed by John:

#syz fix: net/tls: remove close callback sock unlock/lock around TX work flush
