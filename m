Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA3ECCC3
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfKBBTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:19:30 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45271 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKBBTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:19:30 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6E82F22EE3;
        Sat,  2 Nov 2019 02:19:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572657568;
        bh=n66wFU9e1/5ztF0THaHhCzZ3VIo+nOfWFB7o1vML1lo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=saPz2s6hGS8wq8C6OL64p7OwNim0A/yqVlEr+HsXB1K5E7gFBTvFgc6xueABHqPZ7
         C64Tkme19wbyJTvhRT1cOJCP9fkuDfTQccscpsQ9cCKVwxV7Zo+oLI0pQ9Wg7ptxRz
         bFGrjH5YX4q1oqfpkJNCidtakI1R/42sun1lhVpY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 02 Nov 2019 02:19:28 +0100
From:   Michael Walle <michael@walle.cc>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
In-Reply-To: <20191101150322.GB5859@netronome.com>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-3-michael@walle.cc>
 <20191101150322.GB5859@netronome.com>
Message-ID: <46da54da56ce8b5203cfadcf6c86af6b@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2019-11-01 16:03, schrieb Simon Horman:
> On Wed, Oct 30, 2019 at 11:42:50PM +0100, Michael Walle wrote:
>> Document the Atheros AR803x PHY bindings.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  .../bindings/net/atheros,at803x.yaml          | 58 
>> +++++++++++++++++++
>>  include/dt-bindings/net/atheros-at803x.h      | 13 +++++
>>  2 files changed, 71 insertions(+)
>>  create mode 100644 
>> Documentation/devicetree/bindings/net/atheros,at803x.yaml
>>  create mode 100644 include/dt-bindings/net/atheros-at803x.h
> 
> Hi Michael,
> 
> please run the schema past dtbs_check as per the instructions in
> Documentation/devicetree/writing-schema.rst

Hi Simon,

Thank you, I've run the tests and fixed the errors.

-- 
-michael
