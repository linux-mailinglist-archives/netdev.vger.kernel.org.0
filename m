Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8706EC64C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjDXG24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDXG2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:28:55 -0400
Received: from out203-205-251-59.mail.qq.com (out203-205-251-59.mail.qq.com [203.205.251.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB83210C;
        Sun, 23 Apr 2023 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682317729;
        bh=djhr5MfshZUGOTSWt5YmziZxFxkqEBMZM80+QaEbmZg=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=IHbeq3bIXplw6euHBcclHI5Rqs/yl+mO6BSUlK3XTtvGTz5eZ/23wp10C0zLfabnT
         X25xBJ2XX5WkiN993BbzkufJOOVK0THI339+HyCJ12031ybTf0fxVKlNYR0MHJGXzO
         sHqTqDxPEoJsvaFYU3oFF32ROnuoSGIFfUAdDkTc=
Received: from smtpclient.apple ([218.17.26.194])
        by newxmesmtplogicsvrszb1-0.qq.com (NewEsmtp) with SMTP
        id 72D9469F; Mon, 24 Apr 2023 14:28:45 +0800
X-QQ-mid: xmsmtpt1682317725t2oqrawcd
Message-ID: <tencent_308BB7ACC0063D84152850BB24C06E946A09@qq.com>
X-QQ-XMAILINFO: NTPE1iKZ8oO7A7QzEXTbUlnzT8MxX51tkFaPk2idN1nx6HZJycgZT8HX5Ajyxp
         az6pov9QAg+3m1YTLdBysr/MohRb0UeoGM0bu2NQwXbWbZpCEZDArUK6ANa/VfNZH7DCvpSYLYLB
         rSBwLPzPeiuS0lxBrsM6H15MWCDac+nyxRQUqPsLbXBVC+3B5PLhEbyejfL/p+ig1eDtfEtBr6TO
         jdsMUyzdzYyUIDiYHgNJ2pCnT7XEN/Ymvx5foN8dkOpMJR0Zxj3YR6P3yGWAEkQLawKNbUCkr7zJ
         EH+NfQAyjcO8JQm96S9pKv3F34PqJ5glutTUeKiwqVp6ULhu65QWh8I3JwKJFsVDD00vl7yGA+vx
         KCwJIvVnVIQt2u6sYzpzWqw6J+lAEQ6KgWwOA3cGOhvmueuGubCmecqx8dajrBd9sT+nKLi0+0IS
         GbHZ21x1ZF+FQE66RYddeWRyfT+S/2sNnLK0VTA1onTjp1cvcQozdGXcSc53fNPiwYV1v4HFlCbf
         1i3sOSKokluT/Mc5lqPQghDFBqb+rMHxJ7HJJkYz8Q/4n8OsmIPk2DRqWkkhcnUAaVfs5j/RFZzq
         P6ZgeFxC7iqsIaE5jMysLQlFf1dxaBbMFuJUAxcvSzpw4uLLD8ddoG+RtrmD56CbPT0MOl0dQfo4
         6+PLz8Jz3AT+FayNrOZLy9YPjC6YA3lbE2tvjniWuqgyfV9uHRmQUo3rKVQlfjeelGOXh2MBgiZO
         bvZmrKeH1GkX7StUnNZw4iIVwDahxpemfGQPfpbsKaBCaUDR0hhDyQfNZ58Oat5W1zYIG/iVr4J9
         GdRa9yfyWfUZ/DFWMlKF9kk77PcALyo18VhxsrTLphxdCBa9yyHGNB1xx1DjuV7D0g9EzFs88SDq
         AfsX0RAp77DatGiR7UlJ0oz8KWUHK5WjehaijpkXRlsrajf9zS6lie6YMSvKsWsVWKSU1F+ps72i
         Zo9QUTajAU5nyTWQ5x6t8R8aa6OtyvEMO3oxCA43BVf5bEfPlDX0di7S6q+gGnMtGW+LYNbdM=
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in
 rtw_debugfs_set_write_reg
From:   foxmail <zhang_shurong@foxmail.com>
In-Reply-To: <a3450e1f9ee740478f8215feea6127e4@realtek.com>
Date:   Mon, 24 Apr 2023 14:28:35 +0800
Cc:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
X-OQ-MSGID: <37061890-0914-40E4-855F-C843CAE36609@foxmail.com>
References: <cover.1682156784.git.zhang_shurong@foxmail.com>
 <tencent_6E21370EB57D5B7060611EB60A96A88B1208@qq.com>
 <a3450e1f9ee740478f8215feea6127e4@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you a lot for your kind reply, I will resend it as 2 patches.

> 2023=E5=B9=B44=E6=9C=8824=E6=97=A5 09:58=EF=BC=8CPing-Ke Shih =
<pkshih@realtek.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>> -----Original Message-----
>> From: Zhang Shurong <zhang_shurong@foxmail.com>
>> Sent: Saturday, April 22, 2023 6:05 PM
>> To: tony0620emma@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; =
kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; =
linux-kernel@vger.kernel.org; Zhang Shurong
>> <zhang_shurong@foxmail.com>
>> Subject: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in =
rtw_debugfs_set_write_reg
>>=20
>> If there is a failure during copy_from_user or user-provided data
>> buffer is invalid, rtw_debugfs_set_write_reg should return negative
>> error code instead of a positive value count.
>>=20
>> Fix this bug by returning correct error code. Moreover, the check
>> of buffer against null is removed since it will be handled by
>> copy_from_user.
>>=20
>> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
>> ---
>> drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++----
>> 1 file changed, 7 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c =
b/drivers/net/wireless/realtek/rtw88/debug.c
>> index fa3d73b333ba..bc41c5a7acaf 100644
>> --- a/drivers/net/wireless/realtek/rtw88/debug.c
>> +++ b/drivers/net/wireless/realtek/rtw88/debug.c
>> @@ -183,8 +183,8 @@ static int rtw_debugfs_copy_from_user(char tmp[], =
int size,
>>=20
>>        tmp_len =3D (count > size - 1 ? size - 1 : count);
>>=20
>> -       if (!buffer || copy_from_user(tmp, buffer, tmp_len))
>> -               return count;
>> +       if (copy_from_user(tmp, buffer, tmp_len))
>> +               return -EFAULT;
>=20
> This patchset is fine to me. The only thing is this chunk can be first =
patch,
> and squash other patches to second patch because they do the same =
thing
> in the same driver.
>=20
>=20
>>=20
>>        tmp[tmp_len] =3D '\0';
>>=20
>> @@ -338,14 +338,17 @@ static ssize_t rtw_debugfs_set_write_reg(struct =
file *filp,
>>        char tmp[32 + 1];
>>        u32 addr, val, len;
>>        int num;
>> +       int ret;
>>=20
>> -       rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, =
3);
>> +       ret =3D rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, =
count, 3);
>> +       if (ret < 0)
>> +               return ret;
>>=20
>>        /* write BB/MAC register */
>>        num =3D sscanf(tmp, "%x %x %x", &addr, &val, &len);
>>=20
>>        if (num !=3D  3)
>> -               return count;
>> +               return -EINVAL;
>>=20
>>        switch (len) {
>>        case 1:
>> --
>> 2.40.0
>=20
>> -----Original Message-----
>> From: Zhang Shurong <zhang_shurong@foxmail.com>
>> Sent: Saturday, April 22, 2023 6:05 PM
>> To: tony0620emma@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; =
kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; =
linux-kernel@vger.kernel.org; Zhang Shurong
>> <zhang_shurong@foxmail.com>
>> Subject: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in =
rtw_debugfs_set_write_reg
>>=20
>> If there is a failure during copy_from_user or user-provided data
>> buffer is invalid, rtw_debugfs_set_write_reg should return negative
>> error code instead of a positive value count.
>>=20
>> Fix this bug by returning correct error code. Moreover, the check
>> of buffer against null is removed since it will be handled by
>> copy_from_user.
>>=20
>> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
>> ---
>> drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++----
>> 1 file changed, 7 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c =
b/drivers/net/wireless/realtek/rtw88/debug.c
>> index fa3d73b333ba..bc41c5a7acaf 100644
>> --- a/drivers/net/wireless/realtek/rtw88/debug.c
>> +++ b/drivers/net/wireless/realtek/rtw88/debug.c
>> @@ -183,8 +183,8 @@ static int rtw_debugfs_copy_from_user(char tmp[], =
int size,
>>=20
>>        tmp_len =3D (count > size - 1 ? size - 1 : count);
>>=20
>> -       if (!buffer || copy_from_user(tmp, buffer, tmp_len))
>> -               return count;
>> +       if (copy_from_user(tmp, buffer, tmp_len))
>> +               return -EFAULT;
>=20
> This patchset is fine to me. The only thing is this chunk can be first =
patch,
> and squash other patches to second patch because they do the same =
thing
> in the same driver.
>=20
>=20
>>=20
>>        tmp[tmp_len] =3D '\0';
>>=20
>> @@ -338,14 +338,17 @@ static ssize_t rtw_debugfs_set_write_reg(struct =
file *filp,
>>        char tmp[32 + 1];
>>        u32 addr, val, len;
>>        int num;
>> +       int ret;
>>=20
>> -       rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, =
3);
>> +       ret =3D rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, =
count, 3);
>> +       if (ret < 0)
>> +               return ret;
>>=20
>>        /* write BB/MAC register */
>>        num =3D sscanf(tmp, "%x %x %x", &addr, &val, &len);
>>=20
>>        if (num !=3D  3)
>> -               return count;
>> +               return -EINVAL;
>>=20
>>        switch (len) {
>>        case 1:
>> --
>> 2.40.0


