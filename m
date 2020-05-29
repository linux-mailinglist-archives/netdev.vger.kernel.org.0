Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0138B1E8794
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgE2TSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2TSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:18:14 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861D5207D4;
        Fri, 29 May 2020 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590779893;
        bh=vgDSnI+7ypiz1z9yX8VrOTh1GkbhLJZZTXgp3PCi0UI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YNPdyVh2Rx2tMjeDs1WK7/snMQoVXCURWHb8cV872kD8ltBKQUnSNAxdNc1BUn/u7
         W3b2JRZ4+HCLkA+9PiVV1Fhy7VNz2Jd8vQJ94A8N/cbhPGZDeun1sjI0zEo8skGaMz
         yjzqX95r3intpixgnk5qydDy+Q1ttwO2e7UekyhY=
Date:   Fri, 29 May 2020 12:18:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 2/2] bridge: mrp: Add support for role MRA
Message-ID: <20200529121811.583003cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529100514.920537-3-horatiu.vultur@microchip.com>
References: <20200529100514.920537-1-horatiu.vultur@microchip.com>
        <20200529100514.920537-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 10:05:14 +0000 Horatiu Vultur wrote:
> A node that has the MRA role, it can behave as MRM or MRC.
> 
> Initially it starts as MRM and sends MRP_Test frames on both ring ports.
> If it detects that there are MRP_Test send by another MRM, then it
> checks if these frames have a lower priority than itself. In this case
> it would send MRP_Nack frames to notify the other node that it needs to
> stop sending MRP_Test frames.
> If it receives a MRP_Nack frame then it stops sending MRP_Test frames
> and starts to behave as a MRC but it would continue to monitor the
> MRP_Test frames send by MRM. If at a point the MRM stops to send
> MRP_Test frames it would get the MRM role and start to send MRP_Test
> frames.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

net/bridge/br_mrp.c:542:20: warning: cast to restricted __be16
net/bridge/br_mrp.c:542:20: warning: cast to restricted __be16
net/bridge/br_mrp.c:542:20: warning: cast to restricted __be16
net/bridge/br_mrp.c:542:20: warning: cast to restricted __be16
