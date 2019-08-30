Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759F4A3FA1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfH3VZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:25:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:64933 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbfH3VZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 17:25:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 14:25:44 -0700
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="scan'208";a="175731756"
Received: from tsduncan-ubuntu.jf.intel.com (HELO [10.7.169.130]) ([10.7.169.130])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 30 Aug 2019 14:25:44 -0700
Subject: Re: [PATCH] ncsi-netlink: support sending NC-SI commands over Netlink
 interface
To:     Ben Wei <benwei@fb.com>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>
References: <CH2PR15MB36860EECD2EA6D63BEA70110A3A40@CH2PR15MB3686.namprd15.prod.outlook.com>
From:   Terry Duncan <terry.s.duncan@linux.intel.com>
Message-ID: <0da11d73-b3ab-53f6-f695-30857a743a7b@linux.intel.com>
Date:   Fri, 30 Aug 2019 14:25:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CH2PR15MB36860EECD2EA6D63BEA70110A3A40@CH2PR15MB3686.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 5:02 PM, Ben Wei wrote:
> This patch extends ncsi-netlink command line utility to send NC-SI command to kernel driver
> via NCSI_CMD_SEND_CMD command.
> 
> New command line option -o (opcode) is used to specify NC-SI command and optional payload.
> 

Thank you for posting this Ben.
Something looks off on this next line but it looks fine in your pull 
request in the github.com/sammj/ncsi-netlink repo.

> +static int send_cb(struct nl_msg *msg, void *arg) { #define
> +ETHERNET_HEADER_SIZE 16
> +

Do you have plans to upstream your yocto recipe for this repo?
