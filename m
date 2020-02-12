Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3A15AC17
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 16:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgBLPiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 10:38:00 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42894 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgBLPh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 10:37:59 -0500
Received: by mail-pl1-f195.google.com with SMTP id e8so1089961plt.9;
        Wed, 12 Feb 2020 07:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+D92sQbIQX9b/mYM74RryufGT0Oe3W4lj/eAkEZQ33o=;
        b=ERx0Q2v2e6DsNOGzzk7jGKHe9GVGWQubrkyTzlxcGm87Lbm/Ipp20rE/d0kHP3Qrx5
         BaBVCu+4+407P27vgDl38QV6WzlmUGTu+FibnnKjkKYb2FaXb7NMIAB0y6zUQeYk5NR4
         w6Tw0Vd0iGEv5YdMVrUxDPtfzcTdB8afpTI4j3ardAtEqBpGtLhPKaQSDgWA73iN/FME
         LZbfbhMahfU6UIQ9vxElZCb9KkmB6azZKCvFunero33gpIIqwy6UxzPw4heZhgBJtYmT
         FW7iAtVU5nbBfjXfdMEHp6m0iHB1sRA2MfVXRYMAPQUz92onMJyTVqM07mhGDFG1c6lB
         98Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+D92sQbIQX9b/mYM74RryufGT0Oe3W4lj/eAkEZQ33o=;
        b=buckQbwSFbic8K97BGMjL6fHL2wOR46RJGGURAAM1cyqhM+tVPYIr6QSb0TMt/4zLx
         iNgsytsAIT9gbV/sgGXz8opCsSz+miyLwu6mBdt751aa8JTTb40QGboPxsBfnyiKinhe
         8XHT0QweXNk5mrfHqmDY/hFTGwAqT9WkxzUbnpIlndhVVsO/Izph2v9Ng5YTsZRZU824
         j2cUQiMdc9V+uOKD2Sp3+DOTalDvXa7uSQn+uMRhQUmElSMvOxItVOYo8ntRC9cWF4p3
         O5UvMUchaFBKChL+Snafr3qqQf9rUBw6n/gES81hr0ofefAbHYFORVG8t1wk5yZSRFMA
         Jx/w==
X-Gm-Message-State: APjAAAW8dFpbIhqwvmr/gSWz4QIogFfie/uCE2cC9zghOiCeK6vqyB+4
        92XXYlcy5GRXibdiyUxWORU=
X-Google-Smtp-Source: APXvYqzIXChqTVHEHaHlQ9k0LaQMeJkdk7TONDJIcTAVx8iIrqPXCCXuvIOMJ5TNDFOJM+PzmWjDTA==
X-Received: by 2002:a17:902:9f86:: with SMTP id g6mr8225939plq.299.1581521879059;
        Wed, 12 Feb 2020 07:37:59 -0800 (PST)
Received: from fkuchars-mobl1.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id p17sm1295106pfn.31.2020.02.12.07.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2020 07:37:58 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v3] bluetooth: secure bluetooth stack from bluedump
 attack
From:   Johan Hedberg <johan.hedberg@gmail.com>
In-Reply-To: <89D0B633-381D-4700-AB33-5F803BCB6E94@holtmann.org>
Date:   Wed, 12 Feb 2020 17:37:53 +0200
Cc:     Howard Chung <howardchung@google.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <86D0ACD5-BEF7-45B3-B621-BA2E457AB57B@gmail.com>
References: <20200212212316.Bluez.v3.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
 <89D0B633-381D-4700-AB33-5F803BCB6E94@holtmann.org>
To:     Marcel Holtmann <marcel@holtmann.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On 12. Feb 2020, at 17.19, Marcel Holtmann <marcel@holtmann.org> wrote:
>> +		key =3D hci_find_ltk(hcon->hdev, &hcon->dst, =
hcon->dst_type,
>> +				   hcon->role);
>> +
>> +		/* If there already exists link key in local host, leave =
the
>> +		 * decision to user space since the remote device could =
be
>> +		 * legitimate or malicious.
>> +		 */
>> +		if (smp->method =3D=3D JUST_WORKS && key) {
>> +			err =3D mgmt_user_confirm_request(hcon->hdev, =
&hcon->dst,
>> +							hcon->type,
>> +							hcon->dst_type, =
passkey,
>> +							1);
>> +			if (err)
>> +				return SMP_UNSPECIFIED;
>> +			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
>> +		}
>> 	}
>=20
> while this looks good, I like to optimize this to only look up the LTK =
when needed.
>=20
> 	/* comment here */
> 	if (smp->method !=3D JUST_WORKS)
> 		goto mackey_and_ltk;
>=20
>=20
> 	/* and command here */
> 	if (hci_find_ltk()) {
> 		mgmt_user_confirm_request()
> 		..
> 	}
>=20
> And my preference that we also get an Ack from Johan or Luiz that =
double checked that this is fine.

Acked-by: Johan Hedberg <johan.hedberg@intel.com>

Johan=
