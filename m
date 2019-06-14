Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69E946390
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfFNQBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:01:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfFNQBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:01:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3735B1071C312;
        Fri, 14 Jun 2019 09:01:41 -0700 (PDT)
Date:   Fri, 14 Jun 2019 09:01:40 -0700 (PDT)
Message-Id: <20190614.090140.1221151129715562239.davem@davemloft.net>
To:     sergei.shtylyov@cogentembedded.com
Cc:     jeffrey.t.kirsher@intel.com, piotr.marczak@intel.com,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        andrewx.bowers@intel.com
Subject: Re: [net-next 08/12] i40e: Missing response checks in driver when
 starting/stopping FW LLDP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4157b306-b663-e20a-8c24-2d91a049e7fb@cogentembedded.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
        <20190613185347.16361-9-jeffrey.t.kirsher@intel.com>
        <4157b306-b663-e20a-8c24-2d91a049e7fb@cogentembedded.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 09:01:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 14 Jun 2019 12:42:52 +0300

> On 13.06.2019 21:53, Jeff Kirsher wrote:
> 
>> + "Device configuration forbids SW from starting the LLDP agent.\n");
>> +					return (-EINVAL);
> 
>    () not needed. None was used above, so why have them here?
 ...
>> +						 i40e_aq_str(&pf->hw,
>> +							     adq_err));
>> +					return (-EINVAL);
> 
>    Neither they are needed here...

Yeah these need to be fixed.
