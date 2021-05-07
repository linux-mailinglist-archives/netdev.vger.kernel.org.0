Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADB4375DEA
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhEGAho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231720AbhEGAhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:37:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90A5F610FA;
        Fri,  7 May 2021 00:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620347804;
        bh=PJQVhFRNjDo2mg1FVFGXxQVzpJG+hxa1dYKniEl+bOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rt5lVPbMS3YzDgntHSGjOaUlfi41oVo7Xwry9f/7H7r1K1OHC9I0X7YxrHReoVmYP
         5q1WHexpbSThKpHiRyIEjlsTSuVKL9o8KG6ydG1bN0tesWDohOB8Hsxg+NkWOnJIG+
         sNJ4Ty1PbZJj39Wl5PPSceI4wKCX8AiiojkkMeC79e1Xs6LN6W92oryjv4A8e1dU4x
         NrG3/7SwXKF0t+mNF1mIHYxgzqamSTLsP59oGrjGyYVIqLEpfesOeSHf4BkiHw4k8a
         P+TOn0ifnHiqVrQ48ywN0UlWwL8KZrNp/f33+y2fbPYr9ArGvW7Wxldljjpj92FdOu
         VP5l4AtvOGb2A==
Date:   Thu, 6 May 2021 17:36:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Seth David Schoen <schoen@loyalty.org>
Cc:     netdev@vger.kernel.org, gnu@toad.com, dave.taht@gmail.com
Subject: Re: [RESEND PATCH net-next 1/2] ip: Treat IPv4 segment's lowest
 address as unicast
Message-ID: <20210506173643.658e41ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210505232812.GQ2734@frotz.zork.net>
References: <20210505232508.GA1040923@frotz.zork.net>
        <20210505232812.GQ2734@frotz.zork.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 May 2021 16:28:12 -0700 Seth David Schoen wrote:
> Treat only the highest, not the lowest, IPv4 address within a local
> subnet as a broadcast address.

We don't accept patches to net-next during the merge window.

Please repost in a week, please make sure you CC IP maintainers
(get_maintainer script will point them out).
