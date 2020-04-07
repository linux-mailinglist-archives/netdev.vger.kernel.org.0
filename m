Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F551A052C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 05:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDGDNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 23:13:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35410 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgDGDNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 23:13:30 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLefu-00CjN9-CV; Tue, 07 Apr 2020 03:13:18 +0000
Date:   Tue, 7 Apr 2020 04:13:18 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Levi <ppbuk5246@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gnault@redhat.com,
        nicolas.dichtel@6wind.com, edumazet@google.com,
        lirongqing@baidu.com, tglx@linutronix.de, johannes.berg@intel.com,
        dhowells@redhat.com, daniel@iogearbox.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netns: dangling pointer on netns bind mount point.
Message-ID: <20200407031318.GY23230@ZenIV.linux.org.uk>
References: <20200407023512.GA25005@ubuntu>
 <20200407030504.GX23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407030504.GX23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 04:05:04AM +0100, Al Viro wrote:

> Could you post a reproducer, preferably one that would trigger an oops
> on mainline?

BTW, just to make sure - are we talking about analysis of existing
oops, or is it "never seen it happen, but looks like it should be
triggerable" kind of situation?
