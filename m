Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10897241137
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgHJTzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:55:38 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:41802 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgHJTzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:55:37 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07AJtbpu018461
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 14:55:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597089337;
        bh=AVmYQoeVHj8M2tzmLMHMc4GRQesavCJleBKob1BLh9A=;
        h=To:From:Subject:Date;
        b=zJRBxhwlWtK/kQlF5Izn8EJF9rQc+g2AcO2lo9u9GfA2qK6fxU2dgA+xaxRcbsEvi
         U5TaetA/kQg1k8e3PRZ/rWGMAQQrbQPLNmIQAaPrU4ziSoohqG5R12PFkr/n++XR0u
         swtz9hV5JYA5JOcrOoymBubhHuujCsjuZxCyAlsQ=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07AJtbgO005736
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 14:55:37 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 10
 Aug 2020 14:55:36 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 10 Aug 2020 14:55:36 -0500
Received: from [10.250.227.175] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07AJtaRi012904
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 14:55:36 -0500
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Murali Karicheri <m-karicheri2@ti.com>
Subject: HSR/PRP LRE Stats - What is the right user space interface?
Message-ID: <0c743d6e-4a6d-5dcd-88c0-31c6d0971726@ti.com>
Date:   Mon, 10 Aug 2020 15:55:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Netdev experts,

IEC-62439 defines following LRE stats:-

	"lreTxA",
	"lreTxB",
	"lreTxC",
	"lreErrWrongLanA",
	"lreErrWrongLanB",
	"lreErrWrongLanC",
	"lreRxA",
	"lreRxB",
	"lreRxC",
	"lreErrorsA",
	"lreErrorsB",
	"lreErrorsC",
	"lreNodes",
	"lreProxyNodes",
	"lreUniqueRxA",
	"lreUniqueRxB",
	"lreUniqueRxC",
	"lreDuplicateRxA",
	"lreDuplicateRxB",
	"lreDuplicateRxC",
	"lreMultiRxA",
	"lreMultiRxB",
	"lreMultiRxC",
	"lreOwnRxA",
	"lreOwnRxB",

These stats are defined also in the IEC-62439 MIB definition. So
this MIB support is required in Net-SNMP and that requires a proper
kernel interface to pull the values from the HSR or PRP
LRE (Link Redundancy Entity). What is the right interface for this?
Internally TI uses /proc interface for this. But want to check with
community before sending a patch for this. One choice is ethtool for
this. Or something else? Would appreciate if someone can clarify so
that I can work towards a patch for the same.

-- 
Murali Karicheri
Texas Instruments
