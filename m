Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE9FE12D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfD2LTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:19:34 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58346 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727896AbfD2LTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:19:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hL4Jk-0000p0-B4; Mon, 29 Apr 2019 13:19:28 +0200
Message-ID: <459c1807e264def23b14441777a6cda6e432bfc4.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2019-04-26
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Mon, 29 Apr 2019 13:19:27 +0200
In-Reply-To: <20190426090747.20949-1-johannes@sipsolutions.net> (sfid-20190426_110806_141191_A5BAC9FB)
References: <20190426090747.20949-1-johannes@sipsolutions.net>
         (sfid-20190426_110806_141191_A5BAC9FB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Sorry to nag, and maybe I'm missing something, but I didn't see this
show up in your tree, yet you marked it as accepted in patchwork:

https://patchwork.ozlabs.org/patch/1091413/

But maybe there's a gap that I should expect here, like you mark it as
accepted when you start some kind of testing and then push it out later?

Really the only reason I'm asking is that I wanted to forward to apply
another patch, but maybe I'll ask you to apply that one patch directly.

Thanks,
johannes


