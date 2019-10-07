Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EE9CE4AD
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfJGOHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:07:39 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17496 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727324AbfJGOHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:07:39 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97E65HN008406;
        Mon, 7 Oct 2019 16:07:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=dUDvGL9/tLfF861YG+N5fHoN3xp+ryFxh/p5hYpUGqw=;
 b=PpeUf25nys3+H52f/E1VXJDb7CXWsqs/XWjVWCryNs3MzJpmU6KdMvvhVDJxI4ZOfuuN
 UNcHlEUCG2mpktU9oHYswT4KSlxCtXaXLXj+I18GqfHeW8KY5gf6F6k+XCnMCm7/cUUe
 48kZPPa8C1fWRJoCFPBg85WzDR8Xd6FlCQxm10efBDbSU1cI+xRUXKur1tBV1nLuuL/l
 Y9N03z2bYQI0etZMy7dvMJLQDD6DGQ53ISavA0xaLNxmujbSbSE62uYDRSU7Yzr4qX5r
 XkW6TmBapXm787Jf0zfrqW8djEl/MN8rEeJioSUhUPkH57G8Eh+tTgjqAThapFjOYWXb KQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vegxvjpep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 16:07:19 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 92009100038;
        Mon,  7 Oct 2019 16:07:18 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 72D1B2C9064;
        Mon,  7 Oct 2019 16:07:18 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.51) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 7 Oct
 2019 16:07:17 +0200
Subject: Re: [PATCH 2/3] dt-bindings: net: adi: Fix yaml verification issue
To:     Rob Herring <robh+dt@kernel.org>
CC:     Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20191007102552.19808-1-alexandre.torgue@st.com>
 <20191007102552.19808-3-alexandre.torgue@st.com>
 <CAL_JsqKFUTwjJefQvQE5aFmeJButYSLKm0RSpCHjSL=7pQHtxQ@mail.gmail.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <01041a6b-7c70-bebd-d04b-9e47ce238e5e@st.com>
Date:   Mon, 7 Oct 2019 16:07:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKFUTwjJefQvQE5aFmeJButYSLKm0RSpCHjSL=7pQHtxQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG8NODE3.st.com (10.75.127.24) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_02:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob

On 10/7/19 3:56 PM, Rob Herring wrote:
> On Mon, Oct 7, 2019 at 5:26 AM Alexandre Torgue <alexandre.torgue@st.com> wrote:
>>
>> This commit fixes an issue seen during yaml check ("make dt_binding_check").
>> Each enum were not declared as uint32.
>>
>> "Documentation/devicetree/bindings/net/adi,adin.yaml:
>> properties:adi,rx-internal-delay-ps:
>> ..., 'enum': [1600, 1800, 2000, 2200, 2400], 'default': 2000}
>> is not valid under any of the given schemas"
> 
> You need to update dtschema. I fixed this in the meta-schema last
> week. Any property with a standard property unit suffix has a defined
> type already, so we don't need to define it again here.
> 
> I also added '-bits' to standard units.

Nice, I'm going to update my tools.

thanks
Alex

> 
> Rob
> 
