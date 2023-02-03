Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79384689E52
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjBCPa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCPaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:30:23 -0500
X-Greylist: delayed 1688 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 07:30:21 PST
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085B96E9E
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 07:30:20 -0800 (PST)
Received: from 104.47.51.176_.trendmicro.com (unknown [172.21.9.124])
        by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id E1FFC1035426A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 15:02:12 +0000 (UTC)
Received: from 104.47.51.176_.trendmicro.com (unknown [172.21.191.62])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 5EDCA100010AB;
        Fri,  3 Feb 2023 15:02:09 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1675436528.378000
X-TM-MAIL-UUID: 060cd209-3d26-4821-b5c7-b8217db3bb37
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (unknown [104.47.51.176])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 5C8C810001C22;
        Fri,  3 Feb 2023 15:02:08 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM1dirQdQRarPvy/TwtPuE8OPnwuR+m8IMDJDwTPp4C4CqmpAkht9BZAH/dQbLlb+fXxR6vgO93qbMiQNjCkkBeQSIwyLKhv7sCmB2Lzg3fg2/qf1N2bWpeNEto01WlmjW0365G6O/KVMG3/D77YtD2gaCywtuKt26QD3MswEeKpORxr9VF8qVe45SCRo+a37gVln6D8gF3iowltWKEV/AO1foomg8vLai7YgoPm4OtvyPizyfXOVnwZYXowwi5uVbXAPDoibnPsaiTqP+YT4mP6Y1v3OSuHNVOMQ86FpUkBNUQ3KZRdHJ1HHyCxtiWUr+wVt1dz5pFbZ9+ff/ZFvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z03q1zjg9wfUQ3sk0eMvy7V60nwl04F69c1FX/kWtEk=;
 b=MOlksWOmY/X1P6aL9aTT1AMjp07VGXX24nj2+jKaBSeFQraQvjNtWYfT71SpkhGM7gFoIuvfzjwtdpq/IH4GL/nN/2+9JjCXEKHdZ+jUb8ZBgE2RNBuKTCcpN1e5LDUClYS0gxRYWHRcKEBd37LpszN0+555Reava70jlyOSgaVssXgv9Uy361ZCMDA5OvoTBfNnnEu4E4obDjb2WRS5cMq16VjmmoLuAplIKURiFhdgKI7MfoeQ1IIq0cNwgOrrkxegEp7GrVURAXjYa4XltPzdhPnGIzotHDp/m6yw/2BdZKzHYlAZKG+PQtIlzBHDlFkIT5tV+Q8IjJmRE3uU9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <c20ee6cf-2aae-25ef-e97f-0e7fc3f9c5b6@opensynergy.com>
Date:   Fri, 3 Feb 2023 16:02:04 +0100
Subject: Re: [virtio-dev] Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
To:     Arnd Bergmann <arnd@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        stratos-dev@op-lists.linaro.org,
        Matti Moell <Matti.Moell@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
 <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
 <c2c0ba34-2985-21ea-0809-b96a3aa5e401@siemens.com>
 <36bb910c-4874-409b-ac71-d141cd1d8ecb@app.fastmail.com>
Content-Language: en-US
From:   Harald Mommer <hmo@opensynergy.com>
In-Reply-To: <36bb910c-4874-409b-ac71-d141cd1d8ecb@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P250CA0004.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::12) To FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:5f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB2479:EE_|BEZP281MB2659:EE_
X-MS-Office365-Filtering-Correlation-Id: d221f707-cca0-4623-7fe9-08db05f79d90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rbuej+/9mIYOSVv16e+rtfExHKCcvXeyZEU8FcgsqdHIlcdwdxZbwtCThcEbO4x+vlRbr5WrRn2nylObdzgraAjwLYQRIrFs7OnSmieBxFs9GiiTl/dVhTy/wXUA4WywpjBJMoOwLNQ7Qv4BucLNpby4SO1OxnCpfctQ667Pr2o/PjkX3MesSwLl9mqc3/Fo/m6IbETGEIOQdyyEGft52IVN2AvG5xNQP9H+sfsyfHqAHjMbGsGnZZROPOXIOJVutqbhbQ/BHxZRK6DmRXmajP43OPmMsuvyu2NJytWJxSv5aKdVjH0sWI5oE+574o2obWIN+Isk7coXpo7aJX6z2ME+mdxc3GpbTWxCYvsG0Yene6M+cUjhMmOO2AEXtwzi+/P9tzSX82kI4tEaIkFwn7xHYrOncbhrqETYgN33aLT+tSV/BfN7EdBtgBEQK9uhDisFkYB0Fuquv2mkdaOgQX8PXJJCer4vM2TNS+P1NmQqHz7jkCOZWVr/5bcKGtyfo39bMmCf92hPwQeLl2+DjpEeo53pkCCsJ2UKzvnHNEi7D20w/RfAoo9MsrU1zAmDyg7oNGvNsLBEnmkspRE7AQ+2yUNArC8YX2csTKgF4Ln+6rxs6GU0HmwEUkrYjwkof7ZWeeChYPoJoZhbRyX4xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(366004)(346002)(39840400004)(451199018)(31686004)(66946007)(66476007)(4326008)(66556008)(8936002)(8676002)(41300700001)(83380400001)(5660300002)(53546011)(2616005)(6636002)(54906003)(38100700002)(110136005)(2906002)(42186006)(316002)(186003)(31696002)(7416002)(36756003)(26005)(478600001)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlVVb25PY0oyRVdRS05JRVg2SE80SDhsV2hhbWsxaW1CbTZlZ25vWFBCMFBR?=
 =?utf-8?B?TWFPUm9rb2Yxai92WDQ3YkIycmk5TkdjTmI0TkxEY25xam9kL3JmeEpLclVh?=
 =?utf-8?B?K29PK1UvSCswSkV4SU91VDNGWGsxMUhDTjdXNFRUTEFVbEJXYnpQQ3kzd3Vy?=
 =?utf-8?B?R1dZaTI1V3I1WjdlSU83aU5DQThncy9COHRUQThhU3cwQWY2V3pEcmkxZS96?=
 =?utf-8?B?SVVleHVRM2Vma3p6N0VjaDVPYXhFcmlaNytIenRwSW5PRVZlWE5rZkluZnFy?=
 =?utf-8?B?a0tOeGF4U3U1L25wek9ESzRNRzJzSVFyaHJDM3FUeUl0czh0eWluK0JmbnZB?=
 =?utf-8?B?QmN2UFdlWlZ5THZWbDlrOVc0VmNMZVdRNzd0OVZsdnViOTdSZlRDd3lJZkxD?=
 =?utf-8?B?Z2RJN3E4YjBGd1IrcVB4R29rV0d5MGJVQVZ4b1hxVjkrWE05R3VoUi9uUzFa?=
 =?utf-8?B?VWpiMzFySzVsUDVTRnR3NjdRTDlqOVJDVitFUjRsR2ZoZjJTSFFna3B2Q1Bw?=
 =?utf-8?B?TjRKYm5NNnlLUTF0dTlDS2IrM2lRYUFXWTlnZUdUeVlzQmZRdlBtZHZWYSt2?=
 =?utf-8?B?TnBBaEg0M2dPa1dlMW9tUHNYRzJwS1k5bDdTN0QyUXBlZ3ZWRCtBOG1wL3BH?=
 =?utf-8?B?S2R6Rm81TjJDQnJPaG5OU3RjdWk3aTQ0VE5vSmVtdHdMMGdPcmRKTWJzVXFM?=
 =?utf-8?B?NW5Bb2xvN0hDc0tMZGxmTVpIZVg2MGRMRmt5dkdPNEdhVngwZUc4RStJQ3l3?=
 =?utf-8?B?YzBMTk9mK1VUbi9YS0hFbURrWHpKQkYvVW5zb2pEeW1WdEFSbnh6amo3RXdW?=
 =?utf-8?B?S2d3SkhvNlNBZmdWUzBZSWFLZVRQOXMyME9lbFNoMCtOMDFCcHpLNmsvWTlK?=
 =?utf-8?B?Q1NEOU4wZ2RFMk91MDJBMFZzV3ptbEN2bXh2Z3lmelJaWnB2MTZoRDE0N0Ra?=
 =?utf-8?B?eVkvRUsxTGJiLzlJWndFdVI1TXEwbTZMMkVjZXB2QjJCSk1NN2ZiV3NiQktU?=
 =?utf-8?B?N1V6OUtLL3pNYTMyQ2pZZXhSWUF2M3Y0RzcrM0tnc1d5NE0ydk9ZZUIxOHZU?=
 =?utf-8?B?SWloei9NbkwxbGhBdnZDd2dNdjJBalBqMWFFR0RJYmMzZ1ZoV3M3MGxtMFVI?=
 =?utf-8?B?U3dGOHUxUS8yNk0wa215dHN4eFFiSFJOa1N5ZjFobHZ2NFF1eTFDMHpyK3V2?=
 =?utf-8?B?alhwS2hKSXora3h5WnRocDd5NEJPdDJXWmxSSnZpTFdZUFdJSnlUZ1JHbUtl?=
 =?utf-8?B?MEFNb2VmRXZuWUhpWHFHdlFuck1QKzZpVCtLaTR2cmE1NDhZblJOUG9GQ3Q5?=
 =?utf-8?B?N1REN2N5Skg1ckpJU1ZwbVdZc1F1clFLa1AreHdHWHJuWDNFaVI0MXczeDJQ?=
 =?utf-8?B?TmNiMVlLYVVqWTA2ZEJQN2JmWDljWXBORHRXY1NLYzBPQzlvYjg1U2tvc2FY?=
 =?utf-8?B?V0dDa3U1MFFDTmFRRERIaEpSd2JCeTZQZk5VZHA1aFpUS3BoVk5yaGN2cnJn?=
 =?utf-8?B?YVphdDdMeW4wdkhIQUZodXNzMmtnWXdQT0UzbEs2dFJLbmJvZ0JWNUt0cGlP?=
 =?utf-8?B?Zlpwb3FYOFh1eFR5WmZPekc2bWFQRlp1VnN0YlYwUndqUTRpYXRMY2VFTXlj?=
 =?utf-8?B?dm9HdGs5NitScW42ZHZrWjJLU2x5MTAyOTZxdGJXM0dPSW9aVHA2RWEzVlli?=
 =?utf-8?B?djNvSUMvZHFTT3prNy9nR3hsZGlDblFQbThHMFpDZ3B3RFNCQUh3UEVCT1Rk?=
 =?utf-8?B?L1J1SmgxWkV0OGx2Q3g3ZEJTVXBWSzhyTThmRHk0R2NHeVZENThJTUw3Nmdt?=
 =?utf-8?B?d1JhbFI5R1FRd21yRVZUT2ZSUkJIK2NUQ3h6NzZiajhZTEE2RHBTQzZubHBP?=
 =?utf-8?B?NWVyOFoyS2FuN29tQUVocGFycVBBN0dFbXAwV0xDeTJuTVUrWHE3TjRYVWdq?=
 =?utf-8?B?UXhmYlo0cVdXNUlLdDBtWXFCeW1iMGJZZ1RPY2w1ZmFLdHF5eFRPRFRUWWFn?=
 =?utf-8?B?T0lQd1lRRlY4REg0cll3NVJuZTdXM245TmFJVUxPL1FjM3RxNldadVFFdG5E?=
 =?utf-8?B?WFZidnYvc2RXQXZKaWNOcXlVZEphUFl2VGJBRWg3Y3QwSm9GUDJoYzA4M1RB?=
 =?utf-8?Q?1aLqW+5SbS5V9eyk2fW1fegYS?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d221f707-cca0-4623-7fe9-08db05f79d90
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 15:02:06.2860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pafe7xbLkz7jJmcGfCU0LPT7Quw1pxxCHFHMRxEW4xwDeRlmTJJsGDBaId1TipFytt9gqLsDUCUPBoSb8vBUVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2659
X-TM-AS-ERS: 104.47.51.176-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27426.000
X-TMASE-Result: 10--18.361000-4.000000
X-TMASE-MatchedRID: fE0JoqABJp3xlOJuQNHlfWvOwg12ikVSTFQnI+epPIZ0Tsch72XSbIuc
        xKXOxK9OH4Xct13OD6jbne8OA17erhPcKKDHsPAhSXIxnjwYrBT2aiNJz83dB6q9wgXVNwtgZJ4
        Fzcm9y1XmjoYPm6XyGauUE86gbn/6G+3Eurjmqb0shGpBsK6H7rw0XXzM9WrNTPm/MsQarwP5pt
        PWwT6lKYSO7r44vJ4r0VfJE+eWWu3OQ7w/i3HxIq+/qoWUv5IZ2FA7wK9mP9ec2m5O3udcdC+5S
        IjiskLGiovkDxZWmXuKggr79PUAVCQYLRCMVJ+B/sUSFaCjTLxK4f4Z+CZAZ/9qV7U8VoIzrdWe
        E/Aktyyj9oZEw6IQxoPY+q3Rjt7nN9Ukp8r5tE7mYG5eDtyqN0pO/ORUaZ3FmyiLZetSf8nJ4y0
        wP1A6AKEwgORH8p/AjaPj0W1qn0Q7AFczfjr/7M3RarR2HBFFbP0ZC7F11lCYi2MSEouMDJYo+3
        zBur/FYuD6Qew2nZU=
X-TMASE-XGENCLOUD: e34c494c-fd7d-4806-a81b-0e23c93564a9-0-0-200-0
X-TM-Deliver-Signature: 20054729D5297C5822FE17C49F57386F
X-TM-Addin-Auth: 15yi6i/9vJnraIybStA11uWbEm+zsBtR0TcUVa0SeXDOSM0bUFnBRWyInaI
        TrlL6I+/C4F15uQ2Uf8uN19sg/UxfrmYdiEpKXxwxom4HIzSYRMF5fRqlpomzDbrixrjeGI7j64
        +uy7kiQIHN/9pny5wYW3IUuAV1+tBaAo6pPBNSxBUlu8Hke3F6ao0sqP0TC3NXtvcwCpNiSBw27
        zz44t33XuLBQmFeiQWzhqB69s6/IhY0n+oEay1qnhbOEfF/aimtEerkzdiArYVAE3YTB6Tug3N5
        3BuBFaIKAbw+c6I=.g8gk0FUp0jyEh4OWqT+qOd18gS6oVngs2nMA4L5/VHLGdgdJ+KerqPn8n1
        5SqBgv9Vio+rAPHuRv74GAmvApA1ctgb4WImVZTFX8JTrOS5uBKM95NAWLC1dLZrV2XWpA+7FMj
        07mW1w9DigWLWJi+N+77jg7h6NRaBJM5slgH/jhzuNr6IJzZ2ZLcj7ZnWFDLyVBSQShfoAWnq1X
        MexC5kQdIbfXG09JRD6jhAOTXaGwzdVANSD0Mp3iOmCByi9DvDIrqDNL6bLWT0DVsPs92e19oFf
        wCwLIuXLf42xG1yE2Elaxg53faNzZ2PSijgnbMiZdynqRu4sZOxAZd/oS9w==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1675436529;
        bh=fjLk7bc81lsQDOBNZLNxc9XRKMjZJPEv1AUIZeYKt4U=; l=3343;
        h=Date:To:From;
        b=aN6vsZLcX2vSj6DBbttahl47G58wFg6RYH9EwtBzr946Y1Gji69hgIwz0UkkKhBRY
         HYO03mlwqPmVSQ+dh0ANly125S8XERlnn26t67o1usOMOBnooUZriXA1eqt/7Zc3+l
         70Z+OrM/5dbHMA6BNYe1a2ZRSh8Zz/ShVmeOmAUe8VCOoSYOOUXzJvED3jClNt63AN
         oBoy7ox7CWn6fYS5EioDnC/WHLb6wj7Tbinit2/i5zrjjQRzgtz4fN8fW25lkFCn3j
         7yf5WdbkE8fJjm/fxqzbpD3ZrgDY9c2o+mRs9/5axj29J4obS0Wz2HpPYAZaFZhw/h
         wOXbayzRUouSw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

we had here at OpenSynergy an internal discussion about an open source 
virtio-can device implementation.

The outcome of this is now that an open source virtio-can device is to 
be developed.

It has not yet been decided whether the open source device 
implementation will be done using qemu or kvmtool (or something else?). 
Negative or positive feedback for or against one of those is likely to 
influence the decision what will be used as basis for the development. 
Using kvmtool may be easier to do for me (to be investigated in detail) 
but on the other hand we have some people around in the team who have 
the knowledge to support with qemu.


On 04.11.22 18:03, Arnd Bergmann wrote:
> On Fri, Nov 4, 2022, at 16:32, Jan Kiszka wrote:
>> On 03.11.22 14:55, Harald Mommer wrote:
>>> On 27.08.22 11:39, Marc Kleine-Budde wrote:
>>>> Is there an Open Source implementation of the host side of this
>>>> interface?
>>> there is neither an open source device nor is it currently planned. The
>>> device I'm developing is closed source.
>> Likely not helpful long-term /wrt kernel QA - how should kernelci or
>> others even have a chance to test the driver? Keep in mind that you are
>> not proposing a specific driver for an Opensynergy hypervisor, rather
>> for the open and vendor-agnostic virtio spec.
>>
>> But QEMU already supports both CAN and virtio, thus should be relatively
>> easy to augment with this new device.
> Agreed, either hooking into the qemu support, or having a separate
> vhost-user backend that forwards data to the host stack would be
> helpful here, in particular to see how the flow control works.

What I would like to have is considering a CAN frame as sent when it was 
sent on the bus (vs. given to the lower layers where it is only 
scheduled for later transmission but not actually physically sent). This 
behavior is enabled by feature flag VIRTIO_CAN_F_LATE_TX_ACK. But under 
really heavy load conditions this does not work reliably. It looks like 
the own transmitted frames are discarded sometimes in heavy overload.

The reception of the own transmitted frames is used to trigger the state 
transition from "TX pending" => "TX done" for a pending transmitted 
frame in the device. So loosing those own transmitted frames leads to 
the situation that "TX pending" frames stay in this state forever and 
everything gets stuck quickly. So the feature flag 
VIRTIO_CAN_F_LATE_TX_ACK is currently not usable reliably in Linux. 
Either I need to find a good workaround or better a proper way to avoid 
that any of those acknowledgement frames is lost ever. I've no good 
solution found to cope with this yet.

But without VIRTIO_CAN_F_LATE_TX_ACK there is also no working flow 
control. Means I would like to see some day not only "how flow control 
works" but also "that flow control works regardless how the CAN stack is 
tortured".

> IIRC when we discussed virtio-can on the stratos list, one of the
> issues that was pointed out was filtering of frames for specific
> CAN IDs in the host socketcan for assigning individual IDs to
> separate guests.  It would be good to understand whether a generic
> host implementation has the same problems, and what can be
> done in socketcan to help with that.
>
>        Arnd
>
Harald

