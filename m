Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9B51DA2EB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgESUlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:41:10 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:56767 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgESUlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:41:09 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4CEF523058;
        Tue, 19 May 2020 22:41:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589920865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gtxrr4yQdBMq+tJ06ExuPzWxfMF/1G9ILr5yHFsyxVg=;
        b=Srs66gieEYts5zOjcWB+0U5h3l+8a2GpJvCXzkl66NKo3loWrVqcmwT/kp+ev/50YLsc1a
        hZdAuR/9lOR+ppw3PhIjG/1ZDO0djEYwel3zjwx7xjwvhPFNeBvH55Uz+BIewfKh+hrBvx
        IAY7n7SBb+zitR83d0h+8k99BqVKjzU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 19 May 2020 22:41:04 +0200
From:   Michael Walle <michael@walle.cc>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <6e26814b-242e-b60b-a9b5-6ed6608d0fce@ti.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <20200517170601.31832446@apollo>
 <6e26814b-242e-b60b-a9b5-6ed6608d0fce@ti.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <74cc361f175467109b9b43f2d4e5ed53@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2020-05-18 15:36, schrieb Murali Karicheri:
> Hi,
> 
> On 5/17/20 11:06 AM, Michael Walle wrote:
>> What about the Qbu handshake state? And some NICs support overriding
>> this. I.e. enable frame preemption even if the handshake wasn't
>> successful.
> 
> You are talking about Verify procedure to hand shake with peer to
> know if remote support IET fragmentation and re-assembly?
yes

> If yes, this manual mode of provisioning is required as well. So
> one optional parameter needed is enable-verify. If that is not
> enabled then device assumes the remote is capable of fragmentation
> and re-assembly.

sounds good.

-michael
