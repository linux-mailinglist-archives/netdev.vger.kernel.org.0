Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4BB14F0D9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 17:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAaQsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 11:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgAaQsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 11:48:30 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DBD20663;
        Fri, 31 Jan 2020 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580489310;
        bh=RjDOjAfEFNF/6+19JpT8seuHWam68R/PXLK1yp/bddE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YWaZtywFM9dIyzFGSPrDj507x68q+sdoOw/Jc2R/+l0vNDBwQIxFJDe11ZbIss7K9
         5a4WQlzWq2VxYS2dbxgNWHA38cYO5+lD53/mkFqiTmyRHHghzPgV6Cz9iZOwUu54Kw
         pdVC10UKNIy4MvpxY6vQby+0itVCrZdFVuCbY7uE=
Date:   Fri, 31 Jan 2020 08:48:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] ionic: fix rxq comp packet type mask
Message-ID: <20200131084829.15ceddcb@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130180706.4891-1-snelson@pensando.io>
References: <20200130180706.4891-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 10:07:06 -0800, Shannon Nelson wrote:
> Be sure to include all the packet type bits in the mask.
> 
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thank you. 

Please remember not to add empty lines between tags and explain
user-visible impact of fixes.
