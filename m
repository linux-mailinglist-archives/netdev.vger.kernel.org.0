Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A48A984C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 04:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbfIECUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 22:20:32 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44928 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbfIECUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 22:20:32 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so1107803iog.11;
        Wed, 04 Sep 2019 19:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=+G46KvNlLn21VCpvk3pEp2Hl6SbV/sQ0K6A2KKrNWic=;
        b=MqbppkmpjNeCkddBUPrJ/k/lBTska7xLBqjt13AofdQnaNny3T8CPnimKDysxCr6Qu
         5nHhpvrxKtOl0Ah0DhOMX5GdcgmwtzG+5zdW2zEaxeD89rnzcykxQ4CvtHaK+fw6wFHV
         rUx2YGjCujOQVbQAPGMiZauo/ZwcBADMJPKBatnQpT839mO1g4RztxRJy6uBl19Vme/c
         3By/g3IjbIsEx40z4vISu7DcC1yorJ0nV6kD17lsrMaj66XNSCHGz7vLCmBaDWZnB1N6
         V/RRL9PGV6y2AyU27TRFtYmQxLsfYrpiVKzVrCRUf5qontCOl6S2ozbY6niHFn5z7lfo
         gUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=+G46KvNlLn21VCpvk3pEp2Hl6SbV/sQ0K6A2KKrNWic=;
        b=Nozmd6fJlqvKM5u8d0ErvoNIITxSoAlqpaa3PRGqGFcnpnSps7vch/EFplHIs+ORi8
         knRBiUno3qWSyBpbuGPvoUZFV/miK3aFTZkSwAbS+m8LedI/RSM2licoJ3y9v4X/lS5J
         Qa5rT4TWopZLINrj/sD097s7YmcY/FEYbnd3FONYU5hSJ7bxFIDf4jIoeteU2mOgpsCF
         XxVhUf3jxWH16OCl4XQcqG5RcuQIBqnBE6eH0jbCrGnJh1b2GbNX8uiEURI+3JzlAkYW
         5KnMMsoxct5AZE6huoBpJedB7+UhqJcvFC5lQhrfA55weZbdTlcN6dkKjnN2d+XvM4Ln
         U2gA==
X-Gm-Message-State: APjAAAU7x0o5U15+AfesJvMoHaCGZXe957x2+LcjHcJ3lEEBaFsNfRPR
        UgLbfiMNg6O0+IKskz2paoE=
X-Google-Smtp-Source: APXvYqwlQ5dCHOgIjH33DcYephWfaZjfm1Ruj5Me87A/V7PtQhc6DU2gZSDwhuWVocAd2SlOB8QfPA==
X-Received: by 2002:a5e:c311:: with SMTP id a17mr1385428iok.140.1567650030923;
        Wed, 04 Sep 2019 19:20:30 -0700 (PDT)
Received: from [192.168.254.31] ([172.78.24.232])
        by smtp.gmail.com with ESMTPSA id p20sm1663489iod.43.2019.09.04.19.20.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 19:20:29 -0700 (PDT)
Subject: Re: WARNING in hso_free_net_device
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        alexios.zavras@intel.com, andreyknvl@google.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mathias.payer@nebelwelt.net, netdev@vger.kernel.org,
        rfontana@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
References: <0000000000002a95df0591a4f114@google.com>
 <d6e4d2da-66c6-a8fe-2fea-a3435fa7cb54@gmail.com>
 <20190904154140.45dfb398@hermes.lan>
From:   Hui Peng <benquike@gmail.com>
Message-ID: <285edb24-01f9-3f9d-4946-b2f41ccd0774@gmail.com>
Date:   Wed, 4 Sep 2019 22:20:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904154140.45dfb398@hermes.lan>
Content-Type: multipart/mixed;
 boundary="------------F0D63AB9033A22CB69F2E32D"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------F0D63AB9033A22CB69F2E32D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Can you guys have=C2=A0 a look at the attached patch?

On 9/4/19 6:41 PM, Stephen Hemminger wrote:
> On Wed, 4 Sep 2019 16:27:50 -0400
> Hui Peng <benquike@gmail.com> wrote:
>
>> Hi, all:
>>
>> I looked at the bug a little.
>>
>> The issue is that in the error handling code, hso_free_net_device
>> unregisters
>>
>> the net_device (hso_net->net)=C2=A0 by calling unregister_netdev. In t=
he
>> error handling code path,
>>
>> hso_net->net has not been registered yet.
>>
>> I think there are two ways to solve the issue:
>>
>> 1. fix it in drivers/net/usb/hso.c to avoiding unregistering the
>> net_device when it is still not registered
>>
>> 2. fix it in unregister_netdev. We can add a field in net_device to
>> record whether it is registered, and make unregister_netdev return if
>> the net_device is not registered yet.
>>
>> What do you guys think ?
> #1

--------------F0D63AB9033A22CB69F2E32D
Content-Type: text/x-patch;
 name="0001-Fix-a-wrong-unregistering-bug-in-hso_free_net_device.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-Fix-a-wrong-unregistering-bug-in-hso_free_net_device.pa";
 filename*1="tch"

=46rom f3fdee8fc03aa2bc982f22da1d29bbf6bca72935 Mon Sep 17 00:00:00 2001
From: Hui Peng <benquike@gmail.com>
Date: Wed, 4 Sep 2019 21:38:35 -0400
Subject: [PATCH] Fix a wrong unregistering bug in hso_free_net_device

As shown below, hso_create_net_device may call hso_free_net_device
before the net_device is registered. hso_free_net_device will
unregister the network device no matter it is registered or not,
unregister_netdev is not able to handle unregistered net_device,
resulting in the bug reported by the syzbot.

```
static struct hso_device *hso_create_net_device(struct usb_interface *int=
erface,
					       int port_spec)
{
	......
	net =3D alloc_netdev(sizeof(struct hso_net), "hso%d", NET_NAME_UNKNOWN,
      			    hso_net_init);
	......
	if (!hso_net->out_endp) {
   	   	dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
		goto exit;
	}

	......
	result =3D register_netdev(net);
	......
exit:
	hso_free_net_device(hso_dev);
	return NULL;
}

static void hso_free_net_device(struct hso_device *hso_dev)
{
	......
	if (hso_net->net)
		unregister_netdev(hso_net->net);
	......
}

```

This patch adds a net_registered field in struct hso_net to record whethe=
r
the containing net_device is registered or not, and avoid unregistering i=
t
if it is not registered yet.

Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
Signed-off-by: Hui Peng <benquike@gmail.com>
---
 drivers/net/usb/hso.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index ce78714..5b3df33 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -128,6 +128,7 @@ struct hso_shared_int {
 struct hso_net {
 	struct hso_device *parent;
 	struct net_device *net;
+	bool net_registered;
 	struct rfkill *rfkill;
 	char name[24];
=20
@@ -2362,7 +2363,7 @@ static void hso_free_net_device(struct hso_device *=
hso_dev)
=20
 	remove_net_device(hso_net->parent);
=20
-	if (hso_net->net)
+	if (hso_net->net && hso_net->net_registered)
 		unregister_netdev(hso_net->net);
=20
 	/* start freeing */
@@ -2544,6 +2545,7 @@ static struct hso_device *hso_create_net_device(str=
uct usb_interface *interface,
 		dev_err(&interface->dev, "Failed to register device\n");
 		goto exit;
 	}
+	hso_net->net_registered =3D true;
=20
 	hso_log_port(hso_dev);
=20
--=20
2.7.4


--------------F0D63AB9033A22CB69F2E32D
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
upzUiZLN0LKxjlsZTGx9e5m6J0BT
=3DVJU3
-----END PGP PUBLIC KEY BLOCK-----

--------------F0D63AB9033A22CB69F2E32D--
