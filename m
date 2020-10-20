Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3072937F6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392804AbgJTJ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:26:53 -0400
Received: from sonic314-21.consmr.mail.sg3.yahoo.com ([106.10.240.145]:35084
        "EHLO sonic314-21.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392800AbgJTJ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 05:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603186008; bh=TCEah6dQDVULXjjJd0DMU7TiZ3f8rT/CjPbt58XpL8M=; h=Date:From:Reply-To:Subject:References:From:Subject; b=FMI/ihJ5DaI73SrDwl9fT1g/btJ3WLPOgO5K2RyhDyQK2cWo1eD/Xccy2QW30voa6kidG3YCwFOjVwAsYwMDAa7r8s+9s/lzSfXZ+7+HGNSYDhX3hEd2HNas2aJT6xefq6soPRBbhWE6eP23HDwRhOpSz5ZNIqFq1YJS+RrZnL4Y+XgHagT7SHp9qiJiZefcgWMw+M36lXZvZ3slVxEgqdbdI06h2OM9J70cSC5/xLlMhgGniHRVaxOqajGF7pFVEPEiKKbGkfTk+5L0AaZNIRffp5Nmavnj7xdrpWWvttKtoSjCOvs1YMXmeM9qPZJZ+jGzLe0xXFQJWum2kKbKJg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603186008; bh=T1zLEBPJuOgljP06VuzqEc8dZaL+OEoUygKukEuVR3h=; h=Date:From:Subject; b=Lte2fv1o90XP+YZ2WLpMWw1T66tOuJoEzImXF/5rgmBacS048qct9zMlfrvUZMlmKMchS15YJIuy116ID6fxTjcoEcWFCDGx+EvKR2OT/83itELcFKUl69Gl2khRRJOsmwCEa2rCstFun6DCpNsgaaoWYLeEfnhLNcsQTYI8gTWDUBfrkmluG/kypuKB6C8Bj0h0YlOa9evA5OMA7pntELDPPiuC+rCFozE9IqtYHKe1pY8vv5Ohm68maxhfdsC8hnXs5Y4vISIASP3XoB5KzeJxVubpXLysnIZex7JYF6nDHwh/d3UvNCD8qFDlEo2k4WeG8yc5jLvY9vHa8P+cUw==
X-YMail-OSG: WCiqO9UVM1lkAPpnmjtKUFsdwYTayOGUoE5sji5apKEUZk23pb5KrCAZlh.Y6kp
 ekDlkQ4OuuyUBqT1pANtG7mc7XgrBZRZjg5ksSTY.v9F6k6Xspo2E3SZ7r218ubujNU834St3aQJ
 nihx.XLeorkpErmCRxA5wR0OvQyCoLJNyVEe.e8dgkb5ir9pmHsxj0BfVAGEhBlg6PcZ4txWWwGP
 85CyHGxo64A.OfLfb2nSikMX38fBGdaD16HvVeiudJmf._9qBy1cRYPfCZWCdTFHY_REGXbYJH1r
 3VX9GtMfhHSkyRiBl1W4DJl.n3lDsQiGubWClIC6MDcprWDP5IvlNViTDm0EBf6_XeOsS4jzKC5E
 lt4xVWblxOjeHdCAeWbpovLNFzveRqtyoE.Ij_oDXCuawGaOcJqljxfzoOTf6lo5Abl8hiJVSzyu
 NEkjYsd8JQ74F164hCM2q0rXeCLLIneYdmisb5L8qOsqOuuvnJUf1R78NTg7ufhgwmatHllsB2Xz
 oKZWg58CpGts8Hy5G0q1ahLT93tMWNzQnGXzo5h4zft_fty5s6qq7T5ZdY_z7xe9F3ZBj36C7AHf
 rcNXos6Fn.74INpKfuRVUxxIPvWVKeuEdOt2P8Gvq7WkPhghDXFAqVeLP3hJDtK87wqUTx1NFh4F
 Fw.GYvr_7pwlvO1LZ2R1NWGKPuI5s4Ozg99cA1zegSaiRURraL4x3v1qth0zmtuwuUDfIUCoQ_X7
 68.MGAwac62_vNv09EkyFjHJPLsKGtRfDR7gueXsbmU721eIBpvRWza2NmrvTztuX_YWGAWswhTU
 6o5KNtf5nAvGB9kdwVBr4FRhTT8KRTjyuTnyIBh3q5s2gWv1JX3knUv_a1D3JWJXF_gymOoPAzBz
 bjQ_4c7aO6.AvzlHFLRmUaZQW7kB2OioRw8_eUPKbpK7DIQMbIbQhzIDq4ee_Fd2llsVZaWBf7b6
 HgckAc4xit.KbSIkMsiPzOv6Yn_musp0YNuiDR8UsaHlyJcLvJ6tAPYsmM56szDpCjibzH6Y6Db.
 kKUnpJi1B2Txh7e1YA6Y4bSfBarRwheA82DVhOrkzDTdk4HuVcRfHtH0ZBnxBBwVbTC3JVk6vt3R
 OId5.2pnzzvCEXbK4VeUeyZJsdb7bqGbiJzQnu4M9FkDmeJ0gDS8SayxU7iRu.SSNjPVRi0BxXdE
 FL3YU35tHV6XwGQlIJ5FPu1Rtcffog_3SJHoY6Ao497ZJEgsMDuLemxJGz1NGn1sruXYnSqzVjKd
 52N0TNcxWGmmWwvULBSIgJ.OYZXHhccgRLDB5sAFEdFPc1B3orO6crCzNeUPMz7d_qTc.un8EFaO
 KqnxuJPAGtNz_6K4FyVhw9cHZv9l0W5jDitxo4qRztLdqVSMMFFvb.nDDmit23fzMzTX4sRjpZ6v
 DpZ9RSD8oIbTmDxDYckj6SavzUdyjQ6DNV2xL7c4VAkx.bw_8aYsemA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.sg3.yahoo.com with HTTP; Tue, 20 Oct 2020 09:26:48 +0000
Date:   Tue, 20 Oct 2020 09:26:47 +0000 (UTC)
From:   "Mr. Mohamed Musa" <mohmedmusa1964@gmail.com>
Reply-To: mohamedmusa1962@gmail.com
Message-ID: <1405560628.1022654.1603186007602@mail.yahoo.com>
Subject: REPLY ME IMMEDIATELY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1405560628.1022654.1603186007602.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Assalamu alaikum

My name is Mr. Mohamed Musa, I am a staff working with the Bank of Africa here in Ouagadougou,Burkina Faso.

I want you to help me in receiving the sum of Twenty Seven Million Two Hundred thousand Dollars ($27,200,000) into your Bank Account. This fund was deposited in the bank here by a foreign customer who died accidentally alongside with his entire family members many years ago.

Nobody had asked for this fund till now please contact me through my private email address: (mohamedmusa1962@gmail.com) for more details.

Mr. Mohamed Musa.
