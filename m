Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AF51885EF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgCQNfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 09:35:50 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57534 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgCQNft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 09:35:49 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02HDZXeK024397;
        Tue, 17 Mar 2020 08:35:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584452133;
        bh=EYviLt1tmLkkYRzO5gGJjof15MRwO/EmxXKZpB0sQHk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=tMDFRzTMMQ1GDonZySKl3XHX+nAUbToR1HJEl8E6lVspjZJ4YWRsOW8NAbrVQ4MbF
         +KpGYS81qKMBNN9U1mWmp0PSAgNtE+pHtRI15SeA8AUZ2t4R6r3hmDoAoHQlYaq5zV
         k9pRbyhadAnj33LU0IIuComaQYUV4ZPFwzrp4Fvs=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02HDZXg5096136
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 08:35:33 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 08:35:33 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 08:35:33 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02HDZWL5047553;
        Tue, 17 Mar 2020 08:35:32 -0500
Subject: Re: [PATCH 04/12] docs: dt: fix references to m_can.txt file
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <cover.1584450500.git.mchehab+huawei@kernel.org>
 <db67f9bc93f062179942f1e095a46b572a442b76.1584450500.git.mchehab+huawei@kernel.org>
 <376dba43-84cc-6bf9-6c69-270c689caf37@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <60f77c6f-0536-1f50-1b49-2f604026a5cb@ti.com>
Date:   Tue, 17 Mar 2020 08:29:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <376dba43-84cc-6bf9-6c69-270c689caf37@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 3/17/20 8:17 AM, Marc Kleine-Budde wrote:
> On 3/17/20 2:10 PM, Mauro Carvalho Chehab wrote:
>> This file was converted to json and renamed. Update its
>> references accordingly.
>>
>> Fixes: 824674b59f72 ("dt-bindings: net: can: Convert M_CAN to json-schema")

I am trying to find out where the above commit was applied

I don't see it in can-next or linux-can. I need to update the tcan dt 
binding file as it was missed.

And I am not sure why the maintainers of these files were not CC'd on 
the conversion of this binding.

Dan

