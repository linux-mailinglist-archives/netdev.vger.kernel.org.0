Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318E12629C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfEVK65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 06:58:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:39608 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfEVK65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 06:58:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 03:58:56 -0700
X-ExtLoop1: 1
Received: from sneftin-mobl1.ger.corp.intel.com (HELO [10.185.23.132]) ([10.185.23.132])
  by orsmga005.jf.intel.com with ESMTP; 22 May 2019 03:58:55 -0700
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Work around hardware unit hang
 by disabling TSO
To:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Cc:     intel-wired-lan@lists.osuosl.org, thomas.jarosch@intra2net.com,
        netdev@vger.kernel.org
References: <1623942.pXzBnfQ100@rocinante.m.i2n>
 <d308eb17-98ab-13e7-6c74-d701288e43b5@intel.com>
 <3878056.TXPIU5uV5l@rocinante.m.i2n>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <56e233f9-0a50-56f4-c256-38909cfa165b@intel.com>
Date:   Wed, 22 May 2019 13:58:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <3878056.TXPIU5uV5l@rocinante.m.i2n>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/2019 18:42, Juliana Rodrigueiro wrote:
> So I ask myself, how actually feasible is it to gamble the usage of "ethtool"
> to turn on or off TSO every time the network configuration changes?
Hello Juliana,
There are many PCH2 devices with different SKU's.  Not all devices have 
this problem (Tx hand). We do not want to set disabling TSO as the 
default version. Let's keep this option for all other users.
Also, this is very old known HW bug - unfortunately we didn't fixed it. 
Our more new devices have not this problem.
