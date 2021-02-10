Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452BC316F63
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhBJS7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhBJS5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:57:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DA364E2E;
        Wed, 10 Feb 2021 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612983412;
        bh=7dRURo6guQkutfOn7ARkrnDb5BWeD+7itxSw/eJUIfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzogcPc6hHSJxmasWsUrP6HaFVUgC2s7yvPBcixxydaY7YA6QOdCbyUV8HPvymiCs
         Op54nB3yCV2YrhDpUIi85XF6MUql8RrzA1ZGPfrCndMvwNCBKRUKUjPi7mGieqAUmf
         u0mcdnRuUQaIyfxfneL+trkGAEDwXlzzHSUWWBo5Hys6LRngWKgb5EDh/WFWnAvmN4
         PWGXcpt0b/uMPHPpbCqKYywgBihMm+r5XMIcA0aL2tgMEm1ERR2iZrdxbCF1yQjMLM
         XQzys8Y8idwptN0r+0Ml/ZYpA/IrxU+L0XAfJH4n2Gemw/46uaOcTqLFFaCLwNnz3G
         Qc5HpJVPYgKpQ==
Date:   Wed, 10 Feb 2021 10:56:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, mleitner@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v5] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210210105651.61a5c9fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
References: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Feb 2021 14:37:49 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Reject the unsupported and invalid ct_state flags of cls flower rules.
> 
> Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

As long as Cong is okay with the messages:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
