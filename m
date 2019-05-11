Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE961A825
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfEKOyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 10:54:43 -0400
Received: from mout.gmx.net ([212.227.17.22]:52247 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfEKOym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 10:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1557586463;
        bh=Ad8Six8c/BQRteASr2Df0TRVC6SqiftX9K4CihvRBNE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Fga3wEyYWtMLKGs4d+ODg/Ogv0N7Q1EEFqD+PB5iSdR4mEUPcsEjZEuV9SsLIKDpg
         UOrGXXtrOEaN68NMYTArUj168Rji8H1FnnszGXQTz43VvLTG3VZZ10RSVYsYErW2c3
         W76K7AF2iqnirv8B8SGnKMEf2dlNXnD/SS2AHS98=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.11.100] ([95.88.214.118]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Lzsf1-1gcZrw3AOJ-0151eA; Sat, 11
 May 2019 16:54:23 +0200
Subject: Re: stmmac / meson8b-dwmac
To:     Jose Abreu <jose.abreu@synopsys.com>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-amlogic@lists.infradead.org, Gpeppe.cavallaro@st.com,
        alexandre.torgue@st.com,
        Emiliano Ingrassia <ingrassia@epigenesys.com>,
        netdev@vger.kernel.org
References: <a38e643c-ed9f-c306-cc95-84f70ebc1f10@gmx.de>
 <065407cd-c13b-e74c-7798-508650c12caf@gmx.de>
 <227be4e9-b0cc-a011-2558-71a17567246f@synopsys.com>
 <45e73e8c-a0fb-6f8f-8dc6-3aa2103fdda3@gmx.de>
 <e1d75e7f-1747-d0ce-0ee7-4fa688b90d13@synopsys.com>
 <4493b245-de93-46cd-327b-8091a3babc3a@gmx.de>
 <adafe6d7-e619-45e9-7ecb-76f003b0c7d9@synopsys.com>
 <cd0b3dec-af3f-af69-50b7-6ca6f7256900@gmx.de>
 <fa35fb4a-b9d5-9bbb-437d-47e8819d0f27@synopsys.com>
 <244d7c74-e0ca-a9c7-f4b0-3de7bec4024b@gmx.de>
 <1426d8ed40be0927c135aff25dcf989a11326932.camel@baylibre.com>
 <9074d29b-4cc9-87b6-009f-48280a4692c0@gmx.de>
 <d7de65c614ee788152300f6d3799fd537b438496.camel@baylibre.com>
 <8ec64936-c8fa-1f0e-68bf-2ad1d6e8f5d9@gmx.de>
 <f08f2659-dde0-41ec-9233-6b4d5f375ffe@newmedia-net.de>
 <3a040370-e7e5-990e-81dc-8e9bb0ab7761@gmx.de>
 <c21c30e9-e53e-02a5-c367-25898c4614e9@synopsys.com>
 <12d1d6de-2905-46a8-6481-d6f20c8e9d85@gmx.de>
 <2c4d9726-6c2a-cd95-0493-323f5f09e14a@synopsys.com>
From:   Simon Huelck <simonmail@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=simonmail@gmx.de; prefer-encrypt=mutual; keydata=
 mQGiBD/bCNARBACE3URTBXZ/AA03NwRNtz03ewQn3uhvYSTjfqgplBtb3dfC4a79BXDRIWVX
 xPGH9Ewios1c8gMu3/RI2l3JzXoISfw5b0L/5igyPKV+sGuUA2FD27kYtPaaF/TqEWIv+Yxp
 9DCjCX5IQSYyvCfcxcyEkY8eVWxnaAlV3zKRR8wn0wCglWIOtAugBcg1YXmoLpFZE8Ca0fkD
 /jG+n4U9DPfCgkbgjQ/dv2W2a0ZDHccA9N8AW/FTXGyXXO0e7ql9/kORJnp7jD7/Z9HCKpeS
 HajgxuX9Vhfx6bH1dAMfsg88+K8pOO9oulNX1+YffQyZWOfdbmnZDUzBt9HKR9Wgh8WoIyw9
 TVluclzn6hYz+z9jbqHWMOsiCu8zA/0apHbW8vaIDT4+nNUxNdqU1TKa9kW47vNjwYYL0jZW
 TXNjDIRpqJVSugYVc/U847GoVoxyvtzre4TAbBV8h0BAOeMdxI5En67RGWzeNaMDJV1bwapj
 qdfj3e/X8rnGIfwz47rwztLNKoAIUlKrATwroiI7UNT+84G7H5qalu+Eu7QqU2ltb24gSHVl
 bGNrIDxzaW1vbi5odWVsY2tAZ29vZ2xlbWFpbC5jb20+iGIEExECACIFAlH7wL4CGyMGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEJNSVvfBt05KlBQAn1JDO7e4H3N0WFJkZnxvObhk
 2kiAAJwPdDd6T1TuGo4iDIENRhAX4AH2KrkBDQQ/2wjSEAQAj6JnDDQzIIYzPGsrHRvaq8vw
 n8VrZCbPRvkngGvtQIss5pH/MLeu9jLepDGO9WHByFSg4QJh8cINYwTLtX8Bu0naA6ZI46hn
 GyfxdRlxSU9dRqHpU3G0tymL1w3AER6aVSfdXQTmFgf61anKunbIIptkqzZurkjnxkwCE/RM
 RscABA0D/jhglpj8siSIAxs8XLVfKJrjzbYM9/wS0NfdSXBeQJiYtKrY0WMNsqjY50wDnLMg
 anORN/odT6mCwKI6xChzxEv/ta4+teZl92aitziSuqmtl+jm23DpOcUC7UBz2W1+TvnrhPR+
 MKu8pPKAgsE8AI5uwCcNJx7V3bczYkIGaXybiEYEGBECAAYFAj/bCNIACgkQk1JW98G3Tko6
 3wCfZBpZAUhUz/Rcp2rfg/YSKl4YLlEAoJN7e322OvHc2GQ9n1+tKLi6Og4c
Message-ID: <2d7a5c80-3134-ebc0-3c44-9ca9900eade8@gmx.de>
Date:   Sat, 11 May 2019 16:53:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2c4d9726-6c2a-cd95-0493-323f5f09e14a@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BlJSKsW3cKaWy5Sv0qlmZ9rruqoCZJYFmrYg/NdvuxJK3Xa6eHR
 +6ClsS/lXutPrE6tgjlfpapxhMt+XKYLAPG+HYRZImbFHO8bdJ9wAwWcJVEWxYgAmsUfxqp
 QCeSz5k1HZeljg/Jtq2x2PlfOYFpZL8NU88Cw2tRxsMmrk393tAiEdz5H1J0Op2c1AeEvrb
 om+azvUOM2ZAxEHNdSXdg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1cRMGV0D1IY=:v/lJhRUCnNi12w9zv99DFL
 HOi2mqHdK1hpN2LMkCFkvvFozHxVvBXqHT+ApsblX+myuK5mAIdbZQvjzJrdEdhZEH/6KcZd+
 dCvZ8I8pksTmNxTYCqIuIdV794s1+yV7INv/sXyqMVKxHeLfj1UF7kqoZnxqOuQyIvH+vGaEX
 FxvBQ7u6gex6GOnbU6mnjwsg1sRpHalEyl4JcOsJVxgW6TkWCvHocnjLABb6LTKcFyKhMrOZT
 tckpAqMENwSYTDpc5ozIy9E8InwAWKM5r0b5jySXAp580usWPwlLpRoB5lp5ORdrUTs5SoO8C
 2WXhUErRq5in6kHKLNMxBR6nmURcSvz2lbWCiY2XPOLhNxCrmfa5l/4nGSAXcL+GBB930ykX/
 LNJ/ZkXJGaipo0qNOgEOsDvygqpH98Vfir/11dX3L08gznJjeCTgbv5zxKfmKp1cWW+C0tyHr
 xwwaPYuQ96rGGwaAH+SCCfYzlPxlovCNtG1oG4hDzx9EDaEEcS/95a/UQ0t2NpfW6rGrrPBnY
 kW9JwrlGgTLt5QCVpHuqEigF5bWRnkkzjS1jNDxRQO0vxmfF2fo3Fu/InT3UQMPutCH3IXwkb
 bECa3J42BH1i20tfJ4SjDve7B5Qzg5jTHNKq1z+w08xGNLfMirfJ+7x8h1kRSz9a4QrwxIUYZ
 qVuJaZDc6xn+6GREQyeBaTNIZVe1APaujbPlmISV7E4CYLL5s9JrMrhodKMxz8GPUfi6y42+b
 MrZySxoQ1av/EOOTrFc++QS+9aAqmnLQycQ1CazRqOW79alo5iZCnn/a+p1sLzxApTJVuKzoq
 nt71gCXNMMj6uhcE+BDJcz7HVhd75xlC8eqGFwdgU7KUa+x8yhx85MNie7XHrhzvuQ2zxk25e
 Wc56D8oeUMuy4oTLeBVx6IfxB555tqev+ZUjlVEFM26F2JXAeK8z4w+YrDbuYORrDNfcvvz8I
 8M8+M+xI/Cw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

on 5.1+ the story keeps being the same.

950 Mbits in each direction, but when in duplex RX is starving to ~70
MBits..

ethtool -S gave me some counts for mmc_rx_fifo_overflow, which i didnt
recognize before.


Do we have new ideas / new direction to dig for ?


regards,
Simon

Am 01.03.2019 um 10:23 schrieb Jose Abreu:
> Hi Simon,
>
> On 2/27/2019 7:02 PM, Simon Huelck wrote:
>> Hi,
>>
>>
>> the thing is , that im not a stmmac developer. Yes , maybe i can bissec=
t
>> it and yes you are lucky since im a C-developer since a long time for
>> embedded systems.
>>
>> The problem is that i dont understand the structure of stmmac and im no=
t
>> aware of any documentation about the driver structure nor the underlyin=
g
>> ethernet hardware ( even though im used to ethernet hardware in embedde=
d
>> environment ). So how shall i recognize the relevant change between
>> 4.14.29 and 5.0rc8 ?
>>
>>
>> Is it in the DTS/DTB, wrong hardware description ? Is it in the code ?
>> how is the duplex hardware working on this piece ?
>>
>> I can try to support you the best i can, but i have little chances to
>> analyze it myself. At which measurements / counters is it possible to
>> see that duplex is fully working ?=C2=A0 Why did even the non-duplex
>> bandwidth regress from 900MBits to 650 ? Why is that 650 MBits dividing
>> up to TX and RX in summary when doing duplex ? Why is TX not starving i=
n
>> duplex but RX ?
>>
>> From my point of view should be the following things given:
>> - the non duplex bandwidth should be somewhere around 900MBits , the HW
>> is capable of that
>> - TX should not influence RX or vice versa in duplex
>> - the duplex bandwidth should be 900MBits in both directions ( maybe a
>> bit asymetric when buffers in both dirs are not same )
>>
>> I guess we need some profiling on stmmac and ( at least i need ) more
>> knowledge of the hardware and stmmac itself. Can someone point me to th=
e
>> driver documentation, describing the functions in the code and the
>> structure ? How can i profile stmmac ( usually im using hardware / JTAG
>> debuggers at work, but here @home i got nothing like that )
>>
>> So how do we continue ?
> When I said bissect I was meaning GIT Bissect [1]. You shouldn't
> need any development background for this. You just have to start
> bissect, compile, test and check if commit is good or not.
>
> I'm not very familiar with this feature but I think you can
> bissect pretty fast if you say you just want stmmac commits,
> check ("Cutting down bisection by giving more parameters to
> bisect start") on previous link ... In your case it would be
> stmmac changes, dts, and phy.
>
> [1] https://git-scm.com/docs/git-bisect
>
> Thanks,
> Jose Miguel Abreu


