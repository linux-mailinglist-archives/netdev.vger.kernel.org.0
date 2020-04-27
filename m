Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB261B97C3
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 08:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD0GvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 02:51:06 -0400
Received: from mout.web.de ([212.227.17.11]:54797 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgD0GvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 02:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587970248;
        bh=ZQkG6ILo57H/XLt3OxUVo2sAUsr6qnd7jYgNE07wszU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=R1ippfDrPbAS4ugL4SREKVcdAnL92EcAhMdvz6C/fVCGEbXN1diSfWH8GeYN8azQi
         5bBlYI/2RghtdIaXIHT0aau7o4J5MmqFi4KYnu/R3BkKP9dKn1huYgs7Jo6291wLjC
         LnTj0pKowAfNwtxJJ771lojWIgFe8wYg1bloymdw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.190.48]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LfztP-1irDHf0ifT-00peJj; Mon, 27
 Apr 2020 08:50:48 +0200
Subject: Re: [v2 2/3] net: qrtr: Add MHI transport layer
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Chris Lew <clew@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Siddartha Mohanadoss <smohanad@codeaurora.org>
References: <85591553-f1f2-a7c9-9c5a-58f74ebeaf38@web.de>
 <20200427054023.GA3311@Mani-XPS-13-9360>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6affe7d6-4aa1-cd72-74bf-69d8f6c3c98a@web.de>
Date:   Mon, 27 Apr 2020 08:50:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427054023.GA3311@Mani-XPS-13-9360>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hqwHQIkAgeNnxQ3o5ldier3c/E8LT9XEyAYLqXctCS/qTAgLC47
 NGAQXOKPzzoS87sRvbew8iBaoxUwy0KFFOaYjfIMGA+xtDv9NDA4RdAkKRqhfucO25zCQkq
 NBvPChoJe+NY9qO8k5mGWJlMH8iXdJ5G8RLSXjEY41YCJZ1gOkGS8XI/fkiAQVGi90CDLb7
 BjTnQOKUSIDSvdnhQsN9A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rAfKw8V5cJI=:lV0wG3tcKhsjROIajfByVW
 WcrqXpzgaFwMbIPvj10uEaXa2kfqAvB3j3zhTkmC17HL8oZO2JeIJLV+hLkLEMuUFHjQzRtlC
 gYs1eUUsUWr6r0s5JNR6fsHIcmigKDDnI6lwvwuAqg+QViSTEYx3ADGSRZ9/pXZQb1GIsrMbV
 Tinr5e47I84TxL6/xUDx2i48iHK0C9TWvFXG/SSW9LhE/UpdFYGU+KbrF4QW0Xewbkk7CFFRE
 0XlFLBW0LMiG5XHZ0VE/c+pMVGk70uFbdQVTz3DQ9+e+fpGuaY9VAifN1GS+ftTrvIitezsWT
 rQnqrfMnQG+9UlcNGCReafx+fQLVex/7AMhaIAvFzpLZheuRY0PNHLFoTPscBp1sjp+8nuSwU
 qIqggixDdPh3uFcvD+Gh1plG+NCYZ+a6Y9lt/pfywcy38PItthJnM2YsUjo7G6ssZdR5ZqybQ
 ubeKT6c9tlU8fANlizmlfGL/TtMql6ssEgqxAf+hJh6uTZFXzK010OcsuGyLjrwzYHwv12mkA
 +s7anKBzZpg8Qjd3KyWqgQCx/NTt/MFn1PSx6F+G1XUMqTy3rtjU8aZx315p9d/iQDK2De7sk
 928Ae7/9G/e411bxgphebuIwySpr8RyJy413gvFf/utmE78DXHSyq0elgu7lC3KMvkUFBeitR
 UTaSdkJr+sxUs+8GIYtFDZ+RvpScOPaiT+Mtj5pkGhHDbSoNyK0xZua09t+GjRx0nfSMC4orO
 jvvLNxAuCd/wYsAJlUyiTrTgjIMRiqW8wWE3qDVS0GzhDbZCWz3UHuHyYzzWbsG7WfH7XF9h1
 sThp/xYqSz7ezDTMaiFeKhRepafu5ssRvltz2ZrA1Bl2CQ8lDhMxAEnq6hndMnbzZz7qnMyLM
 UNP1VVzdHSJngfIimV7LBpZ1ezBot5lP/MmQx6AXGxKeYRil8zmY1XnTB8JxQ6vg63WbEE0or
 r4W3GVnoOutAiIa8pTA4dn17ueBYpcMdJxfe8rvCOAdqbZRCWAtBCKyQHNrGwZVwNkkvae5Gi
 7OeFmnlnMDJ/YImxZTiFG3cn95gYo0bV3wcitku2+tISUY1NMm6SXwmIijgW8c4cLJJpouDkf
 jbvfNvFNnZD6paPOks/nrLA/7FV4/CqP3VVBzi0HSIiu3XPUIs+8iZ4DP7ypS6Vth1wvI7JUv
 w4/UWaqVOsfvU4PEH7qDvsbqSHs+EQ9acFhKo8kksMzqH7p8Yc63CHeAx8iVZMdd+eE/Pd6+7
 BzEsF8gGKvSUfufs2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I propose again to add a jump target so that a bit of exception handlin=
g code
>> can be better reused at the end of this function implementation.
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/coding-style.rst?id=3Db2768df24ec400dd4f7fa79542f79=
7e904812053#n450
>>
>
> Matter of taste! goto's are really useful if there are multiple exit pat=
hs
> available. But in this case there is only one and I don't think we may a=
dd
> anymore in future. So I'll keep it as it is.

Do you hope that an other optimiser software will avoid duplicate code
like kfree_skb(skb) calls from if branches?

Regards,
Markus
