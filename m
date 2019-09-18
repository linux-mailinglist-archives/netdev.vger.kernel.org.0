Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D0BB5B6C
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfIRF42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:56:28 -0400
Received: from mout.gmx.net ([212.227.17.22]:39969 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfIRF42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 01:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1568786178;
        bh=SHBAQgusYN/vNsT27Odt5tNHlK3DKd8bLnTHS8Z/b1g=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=RpNR00vngsRoFC/fHSs+2cL8WVZJvS8PuseExG10I30QXNU0SQWZ3wN+dkTGuWxU6
         y4s0PML7b4VvXQfHr8Ph+IwYq+jyY4PwkGb0tyPuwtrjT+rXLuJLi+rbDWKFl+708E
         w/ATsyr6W/1dApDa18BwYcktQCoPlBZNVqGNVMuw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.159.39]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McH9Y-1heR3O16xo-00cgGm; Wed, 18
 Sep 2019 07:56:18 +0200
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
To:     John David Anglin <dave.anglin@bell.net>,
        Arlie Davis <arlied@google.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
 <20190917212844.GJ9591@lunn.ch>
 <CAK-9enOx8xt_+t6-rpCGEL0j-HJGm=sFXYq9-pgHQ26AwrGm5Q@mail.gmail.com>
 <df0f961d-2d53-63e3-8087-6f0b09e14317@bell.net>
From:   Helge Deller <deller@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=deller@gmx.de; keydata=
 xsBNBFDPIPYBCAC6PdtagIE06GASPWQJtfXiIzvpBaaNbAGgmd3Iv7x+3g039EV7/zJ1do/a
 y9jNEDn29j0/jyd0A9zMzWEmNO4JRwkMd5Z0h6APvlm2D8XhI94r/8stwroXOQ8yBpBcP0yX
 +sqRm2UXgoYWL0KEGbL4XwzpDCCapt+kmarND12oFj30M1xhTjuFe0hkhyNHkLe8g6MC0xNg
 KW3x7B74Rk829TTAtj03KP7oA+dqsp5hPlt/hZO0Lr0kSAxf3kxtaNA7+Z0LLiBqZ1nUerBh
 OdiCasCF82vQ4/y8rUaKotXqdhGwD76YZry9AQ9p6ccqKaYEzWis078Wsj7p0UtHoYDbABEB
 AAHNHEhlbGdlIERlbGxlciA8ZGVsbGVyQGdteC5kZT7CwJIEEwECADwCGwMGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAFiEE9M/0wAvkPPtRU6Boh8nBUbUeOGQFAlrHzIICGQEACgkQh8nB
 UbUeOGT1GAgAt+EeoHB4DbAx+pZoGbBYp6ZY8L6211n8fSi7wiwgM5VppucJ+C+wILoPkqiU
 +ZHKlcWRbttER2oBUvKOt0+yDfAGcoZwHS0P+iO3HtxR81h3bosOCwek+TofDXl+TH/WSQJa
 iaitof6iiPZLygzUmmW+aLSSeIAHBunpBetRpFiep1e5zujCglKagsW78Pq0DnzbWugGe26A
 288JcK2W939bT1lZc22D9NhXXRHfX2QdDdrCQY7UsI6g/dAm1d2ldeFlGleqPMdaaQMcv5+E
 vDOur20qjTlenjnR/TFm9tA1zV+K7ePh+JfwKc6BSbELK4EHv8J8WQJjfTphakYLVM7ATQRQ
 zyD2AQgA2SJJapaLvCKdz83MHiTMbyk8yj2AHsuuXdmB30LzEQXjT3JEqj1mpvcEjXrX1B3h
 +0nLUHPI2Q4XWRazrzsseNMGYqfVIhLsK6zT3URPkEAp7R1JxoSiLoh4qOBdJH6AJHex4CWu
 UaSXX5HLqxKl1sq1tO8rq2+hFxY63zbWINvgT0FUEME27Uik9A5t8l9/dmF0CdxKdmrOvGMw
 T770cTt76xUryzM3fAyjtOEVEglkFtVQNM/BN/dnq4jDE5fikLLs8eaJwsWG9k9wQUMtmLpL
 gRXeFPRRK+IT48xuG8rK0g2NOD8aW5ThTkF4apznZe74M7OWr/VbuZbYW443QQARAQABwsBf
 BBgBAgAJBQJQzyD2AhsMAAoJEIfJwVG1HjhkNTgH/idWz2WjLE8DvTi7LvfybzvnXyx6rWUs
 91tXUdCzLuOtjqWVsqBtSaZynfhAjlbqRlrFZQ8i8jRyJY1IwqgvHP6PO9s+rIxKlfFQtqhl
 kR1KUdhNGtiI90sTpi4aeXVsOyG3572KV3dKeFe47ALU6xE5ZL5U2LGhgQkbjr44I3EhPWc/
 lJ/MgLOPkfIUgjRXt0ZcZEN6pAMPU95+u1N52hmqAOQZvyoyUOJFH1siBMAFRbhgWyv+YE2Y
 ZkAyVDL2WxAedQgD/YCCJ+16yXlGYGNAKlvp07SimS6vBEIXk/3h5Vq4Hwgg0Z8+FRGtYZyD
 KrhlU0uMP9QTB5WAUvxvGy8=
Message-ID: <f71e9773-5cfb-f20b-956f-d98b11a5d4a7@gmx.de>
Date:   Wed, 18 Sep 2019 07:56:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <df0f961d-2d53-63e3-8087-6f0b09e14317@bell.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FGW6B9MpITsDqYOxyWnfqO/hHy926LVRbpRp1EVpuTcLmG9fhKi
 J1O/uSy/xjY8Vk+8BIEtgMxD3cR51cNqUvIUzMN/g4fKN7nQ8n+fl7gk7JXxOi8HL+Qok0/
 StgilzrnE5+F0/QGrBoz8XppcfS5rCA7/LA2DB+ldfGTi7zJGdbfTYprd6PPWM1axIV6Msy
 alvOh+S0aMX714pkGP/PA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TKTfynUr/uc=:qCyxZMqfjfuMkBh0OxcIT8
 wXqagBhoDpuchjjfdBiRe6k+70w3DUKpYoU8ZP9faO/JkxGEVzROR5hwftzqmZaSDmaRcp2Lv
 PhIOOPSA83ovsERcdsZRrnkIxRivzVE6ztVGMCdBcaefznnBRGYAHzGfFV2PfkLqnOJYXjY75
 l4RGaF3kxRu7wwKE7hk60swEp7NJsTbqmc6yEDj6bE7DsmpX0FYTu0zkeUL97WHF5Fh3AMibi
 e7ehvAK+3pp03GDfvzKEN/1cdeRonmSMwDteD+5vdtcuZmR6BF1KA5tn+EfXBVVMrUUT/CRzM
 cY6lWcfm+Alp7PbzTsQgRSUhOx0WjbaWRK0kIprM9fxlrrcGwWUepjK0r+iJ6BbKLX8TII5UG
 50GvM/NJftm3FuLuoz9dRHS2+iwOEQdkRzpWXfF92hR/l5hG6wq2T9a3nrMmjgJiLoAPRkabx
 Q0j4bxZaEV/nwJH/0gYl2mEqwqLG9N6F2kRsPmHscTeYlRo1xPGltDWASgLKPs7PmWfU7X9+n
 kjx7FeGrk8pX5nY/IZpbSuB/PjX9D8Zl+hKNkJKmW5YlyNuzfcHbB4zOD+4/A5vi2lLoSu096
 K8epa4N24SU/4xRGygdZcAxC1uNmagaD/g9Qb02jcV7ZYfWBC2hVufWlZsD6RHB9vCrkNXqdj
 BCAYJJznF8LMaWHktnzhshNznEt+/8rxvmHX+pKR9dWrXiNg/3fN8pVsQq81Gp70i4KBHKwS0
 BLFWbgFL61ilnkU4t8/mj1Gath19ds+xiMiap31QQa7f3eBqMD9xbnrd4MuM/DxYgBLV8D4uN
 fWffexjuSCUoRJ8P3MYckL378952PrzDaUJzHbPAcmHe0VYZu2tNb4yLkFPDxBIgHGKGc0gCN
 m+jBIMsvRT/zJiaI36UUQx20NnX1Ie+I6uLrZQRmfEf7nKGiiN76r/mlVNfFULHiogq1AOH88
 0OBjKPmXf2blgOLgSFgNAvYWT1YEUjtDv1ObIC9Z/f5W8bB3GaDLAsc0QdXv4XOfjQyRbBaSG
 0JHkFCYTKOT9jlPWougQ9Km/pbhCZGHr24hRPAyKait9WgE4ulpxHwKvfgwGxcp4hLlxD1/q/
 sIOTofTtSlveQa66wQlgnVNd1d70qs5cFSvLOaQ2vMPTw0t89rB3AUKSvglpx8NT8ZcBs2RlC
 0UoXFmg+bveI0mqyHWCpUHB+x+A3EpDSsHQ3S0rfJ9qPQaBip1jrDhMUMWCJZhpvPUCsrQ1wP
 yWm/Wzq21kpLBtCyiHS6MZOfYBC1lI9Lyq2WuvzXzMqXtdVb8QJZKrZQtOVk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.09.19 00:51, John David Anglin wrote:
> On 2019-09-17 5:36 p.m., Arlie Davis wrote:
>> Likewise, I'm at a loss for testing with real hardware. It's hard to
>> find such things, now.
> How does de2104x compare to ds2142/43?=C2=A0 I have a c3750 with ds2142/=
43 tulip.=C2=A0 Helge
> or some others might have a machine with a de2104x.

The machines we could test are
* a C240 with a DS21140 tulip chip (Sven has one),
* a C3000 or similiar with DS21142 and/or DS21143 (me).

If the patch does not show any regressions, I'd suggest to
apply it upstream.

Helge
