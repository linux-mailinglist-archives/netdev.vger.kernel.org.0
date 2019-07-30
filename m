Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928E67A9A3
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbfG3Nbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:31:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfG3Nby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ipPCPvduJeG58ck251y7zMZlHlS0C1cPGDFunTR60Qo=; b=XqOxz6Z1l4u303l949li3CS3+U
        y318daQJQsvr2QEXsuEQLoUOjSbzdFX7OJahipWR6Fx6FlgObjPGvUp+foQW2+g0J9HmnM9S5vgi7
        5UEIm43y8Bg9P3UUq3kPA0sR7VI22YSrUfdkXyIXyK/D27AFZL6yj/Dd8IxtVD/VhbRY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSEL-0007hn-4V; Tue, 30 Jul 2019 15:31:53 +0200
Date:   Tue, 30 Jul 2019 15:31:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA Rate Limiting in 88E6390
Message-ID: <20190730133153.GD28552@lunn.ch>
References: <5a632696-946d-504b-1077-f7eb6d31ec19@eks-engel.de>
 <20190729150158.GE4110@lunn.ch>
 <fd08b6b3-3170-bf44-2f05-a0dd92ea868d@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd08b6b3-3170-bf44-2f05-a0dd92ea868d@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> I've searched the netdev mailing list for DSA and traffic, but can't find anything
> about rate limiting till 2016. Do you have a hint, how I can find it?

I will try to find it later today.
 
> Do you know if the patchset was for Marvell or maybe for another company?

It was another switch vendor.

   Andrew
