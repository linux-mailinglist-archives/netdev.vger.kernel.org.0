Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D7826405
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfEVMtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 08:49:53 -0400
Received: from mout.gmx.net ([212.227.15.18]:60825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfEVMtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 08:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1558529376;
        bh=Q97bXc/PPktmqP9qjjGjOSaN7RwZuTwBfD1GaTGlWT8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jMlxg8/EHFenJktXveeQ7h682zslXJJpcwLmk0IJTiS6bn+3vznj+AzYJ07DP6xZC
         iuLUc85WS8skPMBZZiEgpy8yR9Nu6jW6+dzOmNIFdj0eywFZ6bxkLgkePikYA8X4Vc
         uWXqGU6/9qevTsK/hLjsNCKtchk3Cy7SlwmV0ER4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.11.100] ([95.88.214.118]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MF5FT-1hRZ8m49Pf-00GHMz; Wed, 22
 May 2019 14:49:36 +0200
Subject: Re: stmmac / meson8b-dwmac
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "Gpeppe.cavallaro@st.com" <Gpeppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a38e643c-ed9f-c306-cc95-84f70ebc1f10@gmx.de>
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
 <2d7a5c80-3134-ebc0-3c44-9ca9900eade8@gmx.de>
 <78EB27739596EE489E55E81C33FEC33A0B91BAAE@DE02WEMBXB.internal.synopsys.com>
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
Message-ID: <4f204468-67f4-6d88-ea02-c48f869d8ae3@gmx.de>
Date:   Wed, 22 May 2019 14:48:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B91BAAE@DE02WEMBXB.internal.synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ShOus8Fo/Ar2hBlTIZy9YCIsXOftcGWHyXjUmtHlhlXVE0DBcFx
 ANpfUj7K0TdRfoyDKUYtnfEzzUSKgOcEXcPfXcL0XVQxs2qSDnUYUclVj4Dkie9zH5enO+B
 Bde3hWcKbpaOVbJxiWXrOpvVY2NobKj3od6iCuetnSKqIqNJePwuNcW4K575eygohoPF4G2
 RC4sew3XIxVoc3953e6/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HjuxOAuueoU=:vBu8B3L3BhhBaJwR09OZeR
 iZPGfWDYTxU/J9DMmvjLoQ3lAak+rZfa346rt9Xk4EQ5l8BO64fXZtRhxvXhaGDxSmPQU8FCr
 XcUdAYI94DzCTU0IlSsE3imYdZsnHR25wSBTOKcJZtTUNqgLCgtZ2pXKJ0K8WjvZbB8mmVhBO
 jiC0hxZE32SZvmwA9PokMvArPAao9YcJ5oTklrhuW8PgM0fQGV1p9kTlHbN2ngN60qMIvqgxi
 iYp3VnJ7IK1fx7uljagEYFpxzdiPc9ngZe4MM3RewTfjQQwwurNg0OA8DUrAFg4bLWp+x9Fvc
 QfbIqvcabw/L9R3kQfCY6idt89TB/lcuDPfeQTjGzCdOb0q/pPcvLxJfUOkiBXrjGPVycunEU
 KRXa7kvHcN7TaWUB8Wdn/JEPFmj5VuFCxG0mtoiL1BG4x9+K9EecGgjp1I+VgXIMNk9JE/Jjh
 BRNEntS4OrMifM1irdh6RjtaBcU2h3B2/ZE4CyS6Zz0XzvztmYGG3qsRkw+gopKBfLcyPrEjb
 6pC1O/OyvkhmAHrhJlWlKnjCqi348qrOkkyUd/ZOeLc5R8gTMnFHGIGTeuxutqn1lVYLoFWHV
 fWk9fYCb1yNRMFD1uyYp58oGcCwgyPDf5829pTHEB5UYFpsREj9pfUWC3ITzg/tn03Q6mWur7
 2r0ivJNCpZujnW70MdQNVfUPEiwazcWQTKZjW6bZvVgv1QID7W9ObztcXpyZb3Uw0ujbuxglZ
 Dpnc5hwNsLJBiDly8VwCO7XuSdV1TmSsIwrOA0SbhY+FT/aFnIn4ziHEhzGTzHc31QWplic/6
 zAe1qcsoWmbSdFp3MBsUSmS1YKUJYg4PeffujgIK0V8JKc/G6eFyrZrEZqvnFib8xlezAXfHI
 aM+ptL7kNgbf2IGHgdflCzhOZ1EMHADIYWnZr/5EnHMvUZCiLIJ/09FKVrSwgdt+B46bKrJd8
 CISMv/hemJ3/qcAPSH5TG7GuzhatHtSxJxW4IB8UUBGWOa7o9rTzX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

what exactly do you mean with this DT binding ? i cant find this for
meson gxbb somewhere in the DTS ?

regards,

Simon


Am 13.05.2019 um 11:07 schrieb Jose Abreu:
> From: Simon Huelck <simonmail@gmx.de>
> Date: Sat, May 11, 2019 at 15:53:34
>
>> ethtool -S gave me some counts for mmc_rx_fifo_overflow, which i didnt
>> recognize before.
> Flow Control can prevent this to happen. Please check if your DT FIFO
> bindings are >=3D 4096.
>
>> Do we have new ideas / new direction to dig for ?
> GIT Bisect is the best direction to follow.
>
> Thanks,
> Jose Miguel Abreu


