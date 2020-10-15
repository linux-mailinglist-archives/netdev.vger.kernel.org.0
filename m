Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB628F987
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391679AbgJOTbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391629AbgJOTbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:31:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A29206DD;
        Thu, 15 Oct 2020 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602790278;
        bh=GqHzl00qn5AEO7E2ROQcZTWcUEgEB0IThNJ1kMRFzPE=;
        h=Date:From:To:Cc:Subject:From;
        b=1zBnCC6lNvv1gKpcye0ax0XgUwXvisRg4LVbtDhIrYXSEXicbr8ZM0ZB8YkRqvoGk
         +qv/Xc29XeyxzZoyd4RdcHo/w537LcMv0nX5XQvvHwI4OyBVg+Yk+zP128k8r9DBxk
         skLx4dsXSQmo6cCzoOMFJ5bunikPDA+hmfdHfJX4=
Date:   Thu, 15 Oct 2020 12:31:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: net-next is CLOSED
Message-ID: <20201015123116.743005ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a wrap, please stop sending -next material.

As most of you know from Twitter Dave had a medical emergency 
and we're temporarily on our own :(

I may not be able to flip the "net-next" image on vger, so please 
just watch the mailing list for an announcement when tree opens.
