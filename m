Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F48A8B400
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 11:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfHMJVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 05:21:54 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:47625 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHMJVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 05:21:54 -0400
Received: from [192.168.178.60] ([109.104.47.130]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MAfMc-1i8Vbm2JWi-00B39M; Tue, 13 Aug 2019 11:21:46 +0200
Subject: Re: [PATCH v3 11/17] qca: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michael Heimpold <michael.heimpold@i2se.com>,
        Yangtao Li <tiny.windzz@gmail.com>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
 <20190810101732.26612-12-gregkh@linuxfoundation.org>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <3f49f1c9-9d54-65cb-2462-6e46d0784d4d@i2se.com>
Date:   Tue, 13 Aug 2019 11:21:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190810101732.26612-12-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:1MBg/14MfcbF6b/rZtS1vD/cI2XkGFBs54v/YFWqEhtdS/WHF1P
 LOf1d3j4dMBZYAg7u04DsA9cqmfkW6LSLIdDuI9ke7HurmWyQGJg9OewufAu4H02Smm/dq0
 h3BZPcIrbyVXcTjFnbL3z2F4+QS21C5/prQHWBW1DR+FrnKy//a4GqXdDEndS8swl3upQby
 sWsqy89ECgaMrP0/pA80Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Uaz6vXKfqcw=:iUR7OVZrJNGojv+M3F1uJ0
 kOJUPL1kqurTmtU28j3x4a+PoEA+F6qUKEm3Zm9BR+fZ7YlwMHPWKxUtUc0LoOCLOPAhV9ZYs
 J4oaCkFtFt1LVKQ4mBCyL5kkCGsSWBugI0tvRCbxx+tgx/beTwNJX2HDVTnDCsbCMIzoyhu7/
 j7mvxLGobw6qPgNe8cOyyAaDQIDes+ZnRLKVbIHFEjND41qk5NVDvU8OLWn22qqtpmnPtkXIC
 hv/Wovgwr3lEPOP9pXcNb37Ha5RdYfQuYy2f8RXhCc/CtXIB0RM4KTCMoVC6naBNm2ojhtpoM
 iPyQ9npr0feWA99NtZoYdeQPZkcR1IktVbYUVCRMokuaCt1+bNJbxtxJEo0khX7kHAR11aV2F
 XEgtePXSwHwKE8UP62kyj7nsuIRw7nm5mMYoV2op772LxZSmxG5uxvkR/lYMP6OYQwom1l1fs
 HiyBl5NZ5sHafR41rLMK1v0wPtW83LlLiY1yJfdtWDZfremLcvY/y6ZkUU8FnMYtgFEDCe6t8
 HLiM6cthVJ78fisk+YCSCY9UYvh/XCeLQvKPSznM+SaajSg+q9Brnl0BrUHiNsxaBk6FQlChB
 bxiUxdJO5J8Fkkuum7+Zlf2fwkgrYudwwH/9YDaQixyxraT4TVWF/KscknKlBym5NBnVye5pj
 7OG6fko3TTTcSPsPDt70q4P7EA8cUJhNBi7gb1/hUsQc7Y3OqQ7YTg8lijyeba6/aCV1qEJ7O
 0EDDjZ2RyKrVAUO2+BU6MRqueEQHPEgv9q72IMTCThK5+4tTBKBCk42hQrg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.08.19 12:17, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Michael Heimpold <michael.heimpold@i2se.com>
> Cc: Yangtao Li <tiny.windzz@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Stefan Wahren <stefan.wahren@i2se.com>

