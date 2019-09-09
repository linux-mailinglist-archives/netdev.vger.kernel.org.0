Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD47AD740
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfIIKvq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Sep 2019 06:51:46 -0400
Received: from mail.fuzziesquirrel.com ([173.167.31.197]:54926 "EHLO
        bajor.fuzziesquirrel.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbfIIKvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 06:51:46 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2019 06:51:46 EDT
X-Virus-Scanned: amavisd-new at fuzziesquirrel.com
Received: from brads-mbp.dyn.fuzziesquirrel.com
 (Brads-MBP.dyn.fuzziesquirrel.com [192.168.253.30])
 by bajor.fuzziesquirrel.com (Postfix) with ESMTPSA id 256F95C0A1;
 Mon,  9 Sep 2019 06:46:28 -0400 (EDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] ncsi-netlink: support sending NC-SI commands over Netlink
 interface
From:   Brad Bishop <bradleyb@fuzziesquirrel.com>
In-Reply-To: <CH2PR15MB3686CCC22840AD848796D6CAA3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
Date:   Mon, 9 Sep 2019 06:46:27 -0400
Cc:     Terry Duncan <terry.s.duncan@linux.intel.com>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>
Message-Id: <32645B93-9E92-4945-9840-45E25D0A9351@fuzziesquirrel.com>
References: <CH2PR15MB36860EECD2EA6D63BEA70110A3A40@CH2PR15MB3686.namprd15.prod.outlook.com>
 <0da11d73-b3ab-53f6-f695-30857a743a7b@linux.intel.com>
 <CH2PR15MB3686CCC22840AD848796D6CAA3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
To:     Ben Wei <benwei@fb.com>
X-Mailer: Apple Mail (2.3445.104.11)
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Do you have plans to upstream your yocto recipe for this repo?
>
> Yes I sure can upstream the recipe file. I had to make local changes to  
> build ncsi-netlink for my BMC platform.
> Is there a group I may submit my recipe to?

Hi Ben

Can you try meta-openembedded?  If they will not take it, I’m happy to host  
a recipe for this in meta-phosphor.

In case you have not submitted a patch to meta-openembedded before... the  
correct mailing list is openembedded-devel:

https://www.openembedded.org/wiki/How_to_submit_a_patch_to_OpenEmbedded

thx - brad
