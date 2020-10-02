Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2A281B55
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387806AbgJBTG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgJBTG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:06:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D179AC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 12:06:26 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOQNs-00FPZo-63; Fri, 02 Oct 2020 21:06:24 +0200
Message-ID: <4e1c77dd359c8222358d7c75879f186ff304b16a.camel@sipsolutions.net>
Subject: Re: [PATCH] genl: ctrl: print op -> policy idx mapping
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 02 Oct 2020 21:06:22 +0200
In-Reply-To: <661566db-8fb2-85a2-3147-821c4cb26a1f@gmail.com> (sfid-20201002_200109_559573_1C4A8686)
References: <20201002102609.224150-1-johannes@sipsolutions.net>
         <248a5646-9dc8-c640-e334-31e9d50495e8@gmail.com>
         <58172ec0f7e74c63206121bf6d8f02481f47ee5a.camel@sipsolutions.net>
         <661566db-8fb2-85a2-3147-821c4cb26a1f@gmail.com>
         (sfid-20201002_200109_559573_1C4A8686)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 11:01 -0700, David Ahern wrote:
> 
> does not have to be in the kernel. Usability is important.

Yeah I completely agree with you. I'm just not sure we _can_ here, since
we don't have the domain-specific details.

In a way, I'm really just more or less considering the 'genl' support as
a prototype, for people to look at the code more than looking at the
actual output, because realistically _people_ aren't going to be
consuming this, _programs_ are.

> Since you
> have this compiled and easy to test, what is an example of the output
> for this dump?

Sure, here's nl80211:

	ID: 0x15  op 1 has policy 0
	ID: 0x15  op 2 has policy 0
	ID: 0x15  op 5 has policy 0
	ID: 0x15  op 6 has policy 0
	ID: 0x15  op 7 has policy 0
	ID: 0x15  op 8 has policy 0
	ID: 0x15  op 9 has policy 0
	ID: 0x15  op 10 has policy 0
	ID: 0x15  op 11 has policy 0
	ID: 0x15  op 12 has policy 0
	ID: 0x15  op 14 has policy 0
	ID: 0x15  op 15 has policy 0
	ID: 0x15  op 16 has policy 0
	ID: 0x15  op 17 has policy 0
	ID: 0x15  op 18 has policy 0
	ID: 0x15  op 19 has policy 0
	ID: 0x15  op 20 has policy 0
	ID: 0x15  op 21 has policy 0
	ID: 0x15  op 107 has policy 0
	ID: 0x15  op 22 has policy 0
	ID: 0x15  op 23 has policy 0
	ID: 0x15  op 24 has policy 0
	ID: 0x15  op 25 has policy 0
	ID: 0x15  op 31 has policy 0
	ID: 0x15  op 26 has policy 0
	ID: 0x15  op 27 has policy 0
	ID: 0x15  op 126 has policy 0
	ID: 0x15  op 28 has policy 0
	ID: 0x15  op 29 has policy 0
	ID: 0x15  op 33 has policy 0
	ID: 0x15  op 114 has policy 0
	ID: 0x15  op 32 has policy 0
	ID: 0x15  op 75 has policy 0
	ID: 0x15  op 76 has policy 0
	ID: 0x15  op 37 has policy 0
	ID: 0x15  op 38 has policy 0
	ID: 0x15  op 39 has policy 0
	ID: 0x15  op 40 has policy 0
	ID: 0x15  op 43 has policy 0
	ID: 0x15  op 44 has policy 0
	ID: 0x15  op 45 has policy 0
	ID: 0x15  op 46 has policy 0
	ID: 0x15  op 122 has policy 0
	ID: 0x15  op 48 has policy 0
	ID: 0x15  op 49 has policy 0
	ID: 0x15  op 50 has policy 0
	ID: 0x15  op 52 has policy 0
	ID: 0x15  op 53 has policy 0
	ID: 0x15  op 54 has policy 0
	ID: 0x15  op 55 has policy 0
	ID: 0x15  op 56 has policy 0
	ID: 0x15  op 57 has policy 0
	ID: 0x15  op 58 has policy 0
	ID: 0x15  op 59 has policy 0
	ID: 0x15  op 67 has policy 0
	ID: 0x15  op 61 has policy 0
	ID: 0x15  op 62 has policy 0
	ID: 0x15  op 63 has policy 0
	ID: 0x15  op 65 has policy 0
	ID: 0x15  op 66 has policy 0
	ID: 0x15  op 68 has policy 0
	ID: 0x15  op 69 has policy 0
	ID: 0x15  op 108 has policy 0
	ID: 0x15  op 109 has policy 0
	ID: 0x15  op 79 has policy 0
	ID: 0x15  op 82 has policy 0
	ID: 0x15  op 81 has policy 0
	ID: 0x15  op 83 has policy 0
	ID: 0x15  op 84 has policy 0
	ID: 0x15  op 85 has policy 0
	ID: 0x15  op 87 has policy 0
	ID: 0x15  op 89 has policy 0
	ID: 0x15  op 90 has policy 0
	ID: 0x15  op 115 has policy 0
	ID: 0x15  op 116 has policy 0
	ID: 0x15  op 117 has policy 0
	ID: 0x15  op 118 has policy 0
	ID: 0x15  op 119 has policy 0
	ID: 0x15  op 92 has policy 0
	ID: 0x15  op 93 has policy 0
	ID: 0x15  op 94 has policy 0
	ID: 0x15  op 95 has policy 0
	ID: 0x15  op 96 has policy 0
	ID: 0x15  op 98 has policy 0
	ID: 0x15  op 99 has policy 0
	ID: 0x15  op 100 has policy 0
	ID: 0x15  op 101 has policy 0
	ID: 0x15  op 102 has policy 0
	ID: 0x15  op 103 has policy 0
	ID: 0x15  op 104 has policy 0
	ID: 0x15  op 105 has policy 0
	ID: 0x15  op 106 has policy 0
	ID: 0x15  op 111 has policy 0
	ID: 0x15  op 112 has policy 0
	ID: 0x15  op 121 has policy 0
	ID: 0x15  op 123 has policy 0
	ID: 0x15  op 124 has policy 0
	ID: 0x15  op 127 has policy 0
	ID: 0x15  op 129 has policy 0
	ID: 0x15  op 130 has policy 0
	ID: 0x15  op 131 has policy 0
	ID: 0x15  op 134 has policy 0
	ID: 0x15  op 135 has policy 0
	ID: 0x15  op 136 has policy 0
	ID: 0x15  op 137 has policy 0
	ID: 0x15  policy[0]:attr[1]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[2]: type=NUL_STRING max len:19
	ID: 0x15  policy[0]:attr[3]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[4]: type=NUL_STRING max len:15
	ID: 0x15  policy[0]:attr[5]: type=U32 range:[0,12]
	ID: 0x15  policy[0]:attr[6]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[7]: type=BINARY max len:32
	ID: 0x15  policy[0]:attr[8]: type=U8 range:[0,7]
	ID: 0x15  policy[0]:attr[9]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[10]: type=BINARY max len:16
	ID: 0x15  policy[0]:attr[11]: type=FLAG
	ID: 0x15  policy[0]:attr[12]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[13]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[14]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[15]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[16]: type=U16 range:[1,2007]
	ID: 0x15  policy[0]:attr[17]: type=NESTED
	ID: 0x15  policy[0]:attr[18]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[19]: type=BINARY max len:32
	ID: 0x15  policy[0]:attr[20]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[24]: type=BINARY max len:32
	ID: 0x15  policy[0]:attr[25]: type=U8 range:[0,2]
	ID: 0x15  policy[0]:attr[26]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[28]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[29]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[30]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[31]: type=BINARY min len:26 max len:26
	ID: 0x15  policy[0]:attr[33]: type=STRING max len:2
	ID: 0x15  policy[0]:attr[34]: type=NESTED
	ID: 0x15  policy[0]:attr[35]: type=NESTED
	ID: 0x15  policy[0]:attr[36]: type=BINARY max len:32
	ID: 0x15  policy[0]:attr[37]: type=NESTED
	ID: 0x15  policy[0]:attr[38]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[39]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[41]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[42]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[44]: type=NESTED
	ID: 0x15  policy[0]:attr[45]: type=NESTED
	ID: 0x15  policy[0]:attr[51]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[52]: type=BINARY max len:32
	ID: 0x15  policy[0]:attr[53]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[54]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[55]: type=U32 range:[0,3]
	ID: 0x15  policy[0]:attr[60]: type=FLAG
	ID: 0x15  policy[0]:attr[61]: type=U8 range:[1,255]
	ID: 0x15  policy[0]:attr[62]: type=U8 range:[1,255]
	ID: 0x15  policy[0]:attr[63]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[64]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[65]: type=FLAG
	ID: 0x15  policy[0]:attr[66]: type=U32 range:[0,2]
	ID: 0x15  policy[0]:attr[68]: type=FLAG
	ID: 0x15  policy[0]:attr[70]: type=FLAG
	ID: 0x15  policy[0]:attr[72]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[74]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[75]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[79]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[80]: type=NESTED
	ID: 0x15  policy[0]:attr[82]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[83]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[85]: type=BINARY min len:16 max len:16
	ID: 0x15  policy[0]:attr[87]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[88]: type=U64 range:[0,18446744073709551615]
	ID: 0x15  policy[0]:attr[89]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[90]: type=NESTED
	ID: 0x15  policy[0]:attr[91]: type=BINARY
	ID: 0x15  policy[0]:attr[93]: type=U32 range:[0,1]
	ID: 0x15  policy[0]:attr[94]: type=NESTED
	ID: 0x15  policy[0]:attr[95]: type=FLAG
	ID: 0x15  policy[0]:attr[96]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[97]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[98]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[101]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[102]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[103]: type=FLAG
	ID: 0x15  policy[0]:attr[105]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[106]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[107]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[108]: type=FLAG
	ID: 0x15  policy[0]:attr[109]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[110]: type=NESTED
	ID: 0x15  policy[0]:attr[115]: type=FLAG
	ID: 0x15  policy[0]:attr[116]: type=U8 range:[0,6]
	ID: 0x15  policy[0]:attr[117]: type=NESTED
	ID: 0x15  policy[0]:attr[119]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[122]: type=NESTED
	ID: 0x15  policy[0]:attr[125]: type=NESTED
	ID: 0x15  policy[0]:attr[126]: type=U32 range:[0,2]
	ID: 0x15  policy[0]:attr[127]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[128]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[131]: type=FLAG
	ID: 0x15  policy[0]:attr[132]: type=NESTED
	ID: 0x15  policy[0]:attr[135]: type=FLAG
	ID: 0x15  policy[0]:attr[136]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[137]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[138]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[139]: type=FLAG
	ID: 0x15  policy[0]:attr[140]: type=FLAG
	ID: 0x15  policy[0]:attr[142]: type=FLAG
	ID: 0x15  policy[0]:attr[145]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[146]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[147]: type=FLAG
	ID: 0x15  policy[0]:attr[149]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[150]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[152]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[153]: type=U64 range:[0,18446744073709551615]
	ID: 0x15  policy[0]:attr[154]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[156]: type=BINARY
	ID: 0x15  policy[0]:attr[157]: type=BINARY min len:12 max len:12
	ID: 0x15  policy[0]:attr[158]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[159]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[160]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[161]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[162]: type=U8 range:[0,127]
	ID: 0x15  policy[0]:attr[163]: type=U8 range:[0,1]
	ID: 0x15  policy[0]:attr[164]: type=U32 range:[1,3]
	ID: 0x15  policy[0]:attr[165]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[166]: type=NESTED
	ID: 0x15  policy[0]:attr[171]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[172]: type=BINARY
	ID: 0x15  policy[0]:attr[174]: type=FLAG
	ID: 0x15  policy[0]:attr[175]: type=FLAG
	ID: 0x15  policy[0]:attr[177]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[178]: type=BINARY max len:2304
	ID: 0x15  policy[0]:attr[179]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[180]: type=U16 range:[0,5000]
	ID: 0x15  policy[0]:attr[181]: type=U16 range:[1,2007]
	ID: 0x15  policy[0]:attr[183]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[184]: type=FLAG
	ID: 0x15  policy[0]:attr[185]: type=NESTED
	ID: 0x15  policy[0]:attr[186]: type=BINARY
	ID: 0x15  policy[0]:attr[187]: type=BINARY
	ID: 0x15  policy[0]:attr[189]: type=BINARY
	ID: 0x15  policy[0]:attr[190]: type=BINARY min len:2 max len:253
	ID: 0x15  policy[0]:attr[191]: type=FLAG
	ID: 0x15  policy[0]:attr[194]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[195]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[196]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[197]: type=BINARY
	ID: 0x15  policy[0]:attr[199]: type=BINARY min len:16 max len:58
	ID: 0x15  policy[0]:attr[200]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[201]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[203]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[204]: type=FLAG
	ID: 0x15  policy[0]:attr[205]: type=BINARY
	ID: 0x15  policy[0]:attr[207]: type=FLAG
	ID: 0x15  policy[0]:attr[208]: type=FLAG
	ID: 0x15  policy[0]:attr[209]: type=FLAG
	ID: 0x15  policy[0]:attr[210]: type=U8 range:[0,15]
	ID: 0x15  policy[0]:attr[211]: type=U8 range:[0,7]
	ID: 0x15  policy[0]:attr[212]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[213]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[214]: type=U8 range:[0,255]
	ID: 0x15  policy[0]:attr[215]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[216]: type=FLAG
	ID: 0x15  policy[0]:attr[219]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[220]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[221]: type=FLAG
	ID: 0x15  policy[0]:attr[226]: type=FLAG
	ID: 0x15  policy[0]:attr[227]: type=NESTED
	ID: 0x15  policy[0]:attr[228]: type=U8 range:[0,1]
	ID: 0x15  policy[0]:attr[232]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[235]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[236]: type=FLAG
	ID: 0x15  policy[0]:attr[237]: type=U16 range:[1,2007]
	ID: 0x15  policy[0]:attr[238]: type=U8 range:[1,255]
	ID: 0x15  policy[0]:attr[239]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[240]: type=NESTED
	ID: 0x15  policy[0]:attr[242]: type=BINARY max len:64
	ID: 0x15  policy[0]:attr[243]: type=BINARY min len:32 max len:32
	ID: 0x15  policy[0]:attr[244]: type=FLAG
	ID: 0x15  policy[0]:attr[245]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[0]:attr[246]: type=S8 range:[-128,127]
	ID: 0x15  policy[0]:attr[248]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[249]: type=BINARY max len:16
	ID: 0x15  policy[0]:attr[250]: type=BINARY max len:253
	ID: 0x15  policy[0]:attr[251]: type=U16 range:[0,65535]
	ID: 0x15  policy[0]:attr[252]: type=BINARY max len:64
	ID: 0x15  policy[0]:attr[253]: type=BINARY min len:2 max len:2
	ID: 0x15  policy[0]:attr[254]: type=BINARY max len:64
	ID: 0x15  policy[0]:attr[255]: type=FLAG
	ID: 0x15  policy[0]:attr[258]: type=BINARY min len:16 max len:16
	ID: 0x15  policy[0]:attr[261]: type=FLAG
	ID: 0x15  policy[0]:attr[264]: type=FLAG
	ID: 0x15  policy[0]:attr[266]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[267]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[268]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[0]:attr[269]: type=BINARY min len:16 max len:54
	ID: 0x15  policy[0]:attr[270]: type=NESTED policy:1 maxattr:3
	ID: 0x15  policy[0]:attr[272]: type=U32 range:[1,4294967295]
	ID: 0x15  policy[0]:attr[273]: type=NESTED policy:2 maxattr:5
	ID: 0x15  policy[0]:attr[274]: type=U16 range:[1,65535]
	ID: 0x15  policy[0]:attr[275]: type=U8 range:[0,2]
	ID: 0x15  policy[0]:attr[276]: type=S16 range:[-32768,32767]
	ID: 0x15  policy[0]:attr[277]: type=BINARY max len:128
	ID: 0x15  policy[0]:attr[278]: type=FLAG
	ID: 0x15  policy[0]:attr[279]: type=NESTED policy:3 maxattr:2
	ID: 0x15  policy[0]:attr[280]: type=U8 range:[1,60]
	ID: 0x15  policy[0]:attr[281]: type=U8 range:[4,15]
	ID: 0x15  policy[0]:attr[282]: type=U16 range:[1,4094]
	ID: 0x15  policy[0]:attr[283]: type=NESTED policy:4 maxattr:3
	ID: 0x15  policy[0]:attr[285]: type=NESTED_ARRAY policy:5 maxattr:13
	ID: 0x15  policy[0]:attr[286]: type=FLAG
	ID: 0x15  policy[0]:attr[287]: type=U32 range:[1,4294967295]
	ID: 0x15  policy[0]:attr[288]: type=U8 range:[1,100]
	ID: 0x15  policy[0]:attr[289]: type=FLAG
	ID: 0x15  policy[0]:attr[290]: type=U32 range:[0,999]
	ID: 0x15  policy[0]:attr[291]: type=U32 range:[0,999]
	ID: 0x15  policy[0]:attr[292]: type=NESTED
	ID: 0x15  policy[0]:attr[293]: type=BINARY min len:2 max len:2
	ID: 0x15  policy[0]:attr[294]: type=NESTED policy:6 maxattr:3
	ID: 0x15  policy[0]:attr[295]: type=NESTED policy:7 maxattr:2
	ID: 0x15  policy[1]:attr[1]: type=FLAG
	ID: 0x15  policy[1]:attr[2]: type=BINARY max len:255
	ID: 0x15  policy[1]:attr[3]: type=BINARY max len:255
	ID: 0x15  policy[2]:attr[5]: type=NESTED_ARRAY policy:8 maxattr:4
	ID: 0x15  policy[3]:attr[1]: type=U8 range:[1,20]
	ID: 0x15  policy[3]:attr[2]: type=U8 range:[1,20]
	ID: 0x15  policy[4]:attr[1]: type=U8 range:[1,63]
	ID: 0x15  policy[4]:attr[2]: type=FLAG
	ID: 0x15  policy[4]:attr[3]: type=FLAG
	ID: 0x15  policy[5]:attr[2]: type=U64 range:[0,18446744073709551615]
	ID: 0x15  policy[5]:attr[3]: type=U64 range:[0,18446744073709551615]
	ID: 0x15  policy[5]:attr[4]: type=FLAG
	ID: 0x15  policy[5]:attr[5]: type=U16 range:[1,255]
	ID: 0x15  policy[5]:attr[6]: type=U8 range:[0,1]
	ID: 0x15  policy[5]:attr[7]: type=U8 range:[1,255]
	ID: 0x15  policy[5]:attr[8]: type=U8 range:[1,255]
	ID: 0x15  policy[5]:attr[9]: type=U8 range:[0,1]
	ID: 0x15  policy[5]:attr[10]: type=U8 range:[0,1]
	ID: 0x15  policy[5]:attr[11]: type=U8 range:[0,1]
	ID: 0x15  policy[5]:attr[12]: type=U8 range:[0,2]
	ID: 0x15  policy[5]:attr[13]: type=NESTED policy:9 maxattr:7
	ID: 0x15  policy[6]:attr[1]: type=U32 range:[0,10000]
	ID: 0x15  policy[6]:attr[2]: type=U32 range:[0,10000]
	ID: 0x15  policy[6]:attr[3]: type=BINARY min len:42 max len:2304
	ID: 0x15  policy[7]:attr[1]: type=U32 range:[0,20]
	ID: 0x15  policy[7]:attr[2]: type=BINARY max len:2304
	ID: 0x15  policy[8]:attr[1]: type=BINARY min len:6 max len:6
	ID: 0x15  policy[8]:attr[2]: type=NESTED policy:0 maxattr:295
	ID: 0x15  policy[8]:attr[3]: type=NESTED policy:10 maxattr:2
	ID: 0x15  policy[9]:attr[1]: type=BINARY max len:32
	ID: 0x15  policy[9]:attr[2]: type=BINARY max len:77
	ID: 0x15  policy[9]:attr[3]: type=BINARY min len:16 max len:16
	ID: 0x15  policy[9]:attr[4]: type=U8 range:[0,255]
	ID: 0x15  policy[9]:attr[5]: type=BINARY min len:16 max len:16
	ID: 0x15  policy[9]:attr[6]: type=U8 range:[0,2]
	ID: 0x15  policy[9]:attr[7]: type=U8 range:[0,2]
	ID: 0x15  policy[10]:attr[1]: type=NESTED policy:11 maxattr:1
	ID: 0x15  policy[10]:attr[2]: type=FLAG
	ID: 0x15  policy[11]:attr[1]: type=NESTED policy:12 maxattr:11
	ID: 0x15  policy[12]:attr[1]: type=FLAG
	ID: 0x15  policy[12]:attr[2]: type=U32 range:[0,4294967295]
	ID: 0x15  policy[12]:attr[3]: type=U8 range:[0,15]
	ID: 0x15  policy[12]:attr[4]: type=U16 range:[0,65535]
	ID: 0x15  policy[12]:attr[5]: type=U8 range:[0,15]
	ID: 0x15  policy[12]:attr[6]: type=U8 range:[0,31]
	ID: 0x15  policy[12]:attr[7]: type=U8 range:[0,255]
	ID: 0x15  policy[12]:attr[8]: type=FLAG
	ID: 0x15  policy[12]:attr[9]: type=FLAG
	ID: 0x15  policy[12]:attr[10]: type=FLAG
	ID: 0x15  policy[12]:attr[11]: type=FLAG

johannes

