Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CFB32320F
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhBWU1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231742AbhBWU1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:27:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC97264E6B;
        Tue, 23 Feb 2021 20:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614112002;
        bh=g14x86v7bB0pekZdzkp/EB47w42LOCur/6lv0xg8pus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oyfhtb2Y/pAihIp/iotJOSo80C/TEh/9UjlWlS/rHl0gaX7RQV5QxS0hNGuKnOKby
         UOIAlzZXnBJFF58EKFbY73+9MBoEmrSU8lZIg3AlxUe5dQ1rhJC1ISZL09BXG6hKH8
         xGGD3tfxZvUwUn23+rArSruO4TkqP4xqzlEYeZLbEFsWRVclCL1gtzXuc73/UgT/LF
         JgrCfWYl98TIomJHfHpouCvbB5g5xLIh1KmpbpoIK7R2E+dyaC90X+mklwr5/FeujH
         2LCHo+afrTIOIXGeTczt73jNqoIweH2iMSwTto4mZHsJtGKbOKSt77vt+WFlIGuxOc
         d0Bjxda1QwIwg==
Date:   Tue, 23 Feb 2021 12:26:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>, wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net-next v2] net/sched: cls_flower: validate ct_state
 for invalid and reply flags
Message-ID: <20210223122638.3bcee5b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223120547.GT2953@horizon.localdomain>
References: <1614064315-364-1-git-send-email-wenxu@ucloud.cn>
        <20210223120547.GT2953@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 09:05:47 -0300 Marcelo Ricardo Leitner wrote:
> On Tue, Feb 23, 2021 at 03:11:55PM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > Add invalid and reply flags validate in the fl_validate_ct_state.
> > This makes the checking complete if compared to ovs'
> > validate_ct_state().
> > 
> > Signed-off-by: wenxu <wenxu@ucloud.cn>  
> 
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thank you!
