Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37439C154
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhFDUa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:30:56 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:59753 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhFDUaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 16:30:55 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7DCFF2224D;
        Fri,  4 Jun 2021 22:29:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1622838546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G77K+vxEcexOlrNxgaLbjHCcwIRayXoTYp3Ij729bNU=;
        b=gBrGrzikvVFins/jmzbxRlNgDbTAM097FPe6i49VN7MBY2D0isgJ1jlKdqKM2LqHzq/982
        8j8rTMOXSLIkVYMqae+KkZZHTzEkVxq2rfOprePwlS3qpvZAvn+dAHt7waMimzzFPq2wgT
        5K/oIuuEy4rVIZHRHM9ZBu1porGUrng=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Jun 2021 22:29:06 +0200
From:   Michael Walle <michael@walle.cc>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 2/2] MAINTAINERS: move Murali Karicheri to credits
In-Reply-To: <20210604191141.GA2228033@bjorn-Precision-5520>
References: <20210604191141.GA2228033@bjorn-Precision-5520>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <0dfdcc21c82179773de5a83e04d4247a@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

Am 2021-06-04 21:11, schrieb Bjorn Helgaas:
> On Thu, Apr 29, 2021 at 11:05:21AM +0200, Michael Walle wrote:
>> His email bounces with permanent error "550 Invalid recipient". His 
>> last
>> email was from 2020-09-09 on the LKML and he seems to have left TI.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# TI KeyStone PCI driver
> 
> I could take both, given a networking ack for [1/2].  Or both could go
> via the networking tree.

This patch was already picked up via the network queue (quite some time
ago).

-michael
