Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF30A332B0
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfFCOwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:52:31 -0400
Received: from sonic309-48.consmr.mail.bf2.yahoo.com ([74.6.129.222]:34449
        "EHLO sonic309-48.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729038AbfFCOwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1559573549; bh=ASdX86yUYRsxIlZvXAdrB/RwQ9ZomONpQNmJPYz3O9E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hJIuO7YItKewfDvp5EH68QcdxMxoE3VOKYbS3iah+hjg4lazXFmDkK/UPSybWxT6weIiXsNHCliw3RMgonDlz856+OdH8femZkHE2cwbaB0oORGRA7NiHy8+0XTf1IygYAc5kdHxL6EG52cKO9heLrJPVnSRwqLiEWxWVxRbHz9BvrsfOZzVX6anVhrDKvvyPBLaMqfMVipE0yP2ILdexiUSO/RBg//rbHG140bq7tNXnkMGcoi0SFMffZdCj/cO9vqAjEaDUnDnX7RSXKsEUVsFXDLFeWGJ9j2LdqscHpVAneVwPPg7wU3Emn9Tfajd9Svcx1IBMcLv98pdXDh33w==
X-YMail-OSG: qgJEJ_kVM1nhayc8188jzrqR2kWRRwP4vFM_ObN12BNBdOTO47rA4TFHijJeQe2
 e8_4Jd3Ny7nuhMW9v3gxN4Dja9gAz_Rh3jfpFFiKTWZBSbFUHR69bErirDaStqszhq5TTpsjGwdG
 iRXQwg8S7zQKDdvA5YrOKj9WhgQ3ItdB6v59aj39tAKkcHA2l3e.3cLoobjl_MaEEv11.8_KJzXI
 V_syVoa2hHxVqorma4Gp3EOUxhB5iwt_7zZFXSASEFemu5EhgzRK23uuKm8qukxhazMCKyPUvsdV
 SReYeZxNDae8tJo.wMqRB8zuA9SBZ_DZQdeDDYxNiE1aPtGGP3MQdaV6xRdPdZtmAb4G5eevpJm5
 4m5y2g89tXy2wmmN4z0LtKFJnykycpdYoCb2WNXrUiZi4V_j1fpxFnJ0ysFpFXxVSHjS.ulTJCRH
 Ikt78sSCZtRO_Q1aauRwjzAai4cd7tYxXeEf16US0IKXMdp8nUZJJsSttj6B1bicqwVnbo4d.vcT
 FRUHev0psUjqe7o3HPCUxX41ZFaNsrewPsKx_PJtlBqIctqJnuC3O2iF2KQCkqxQOEnWF9P1e9.g
 K.7A4QdMKQHEwqAO.KQIH9zigmSF_OH05XbRvvyt3sZN0ljmnQ5WSRX53nasMIp938Q6J5H8SdQ7
 eaKhMRgUzi1.K90aDvfoboVY__bx4qkqu2VCezgC8thlicdS6RwQ4JvUZfSmQxL6g6Yu8JBAdSuZ
 fKN96PlxFqs7WljQIggYXWt2XFl3Et5o4.MFTgdjVj9MfNCZ7O9j94wkkB_mjbauQif6_9JX7r2C
 Qk3aUroIiK1gVL8f_1qCXFn12xbGGxZwvTgOBSj6qUPQnHPNEBmmNeJUxsTUx7252v2n5V9YligB
 hLy98RN5ONf94euaQ22x3bzpeaYFCjf3GTiOeTP20_EEc0Fp0qAYYweim9a4SBjEDB23_qXinb8G
 i1nLmeKvAyBikcFeyMWJmDL7RetodwgoWYYiBCFrckMHC2lngL9cIH_VLiBCzcGVJ6DQo94zKHjp
 y2llNZE00X56MSw9wVzNDyyfqbRPaYFBc79yPS1IrrXLQSWHroXKETcefBfVozCc.xlrAhRhDpI7
 gtwBbm1EBmyOhJE26s1DRR0iN90joVd0tSSCwxKRkmwj3IqYiyQ5G.qj.gxvvaGAFHU7mImIFB2R
 3vH4AfBbhFcJfCpn1ddHwM3EqY8UGQmtnNh7wHfA.4SQmELwrH9oWSwMP.C8nYHa0ovY3ya7wjXE
 XC2lb.eIAIzmAajQtczck715jdA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Mon, 3 Jun 2019 14:52:29 +0000
Date:   Mon, 3 Jun 2019 14:50:28 +0000 (UTC)
From:   Major Dennis Hornbeck <bc37@bkgriup.online>
Reply-To: Major Dennis Hornbeck <hornbeckmajordennis635@gmail.com>
Message-ID: <1655321178.7300322.1559573428986@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1655321178.7300322.1559573428986.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I am in the military unit here in Afghanistan, we have some amount of funds that we want to move out of the country. My partners and I need a good partner someone we can trust. It is risk free and legal. Reply to this email: hornbeckmajordennis635@gmail.com

Regards,
Major Dennis Hornbeck.
