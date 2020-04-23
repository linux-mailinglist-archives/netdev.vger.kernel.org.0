Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACF81B516D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDWAjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgDWAjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 20:39:36 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A824AC03C1AA;
        Wed, 22 Apr 2020 17:39:34 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id t11so3318661lfe.4;
        Wed, 22 Apr 2020 17:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5fl4A7nRdQONkc+Ns32BwHf/X7YnX+et/nIg9JJL2zU=;
        b=Mj30sjvrkHvbKMqqfHKFNV5+YQEGBrwRZ0z+4T3vXh7n5MBP9x3dRJ6j2LmHioOge6
         QYB43T4G4zJsbQVQ7BH3EqooNVpHMppSpitVpDBQztmzTnG24oBhFVzD/pbnt9ghXCDO
         lIPvj3hYEECgw/yZYPuNE0KHnYN0oFHy/bnaLJb8G8jh4Pwt0ER9hkd3ECRaHkHJU+iO
         goBbHo0eb/KFYdoDWis9mS1esjCM8LF+3/iN/bWJpmfHjiEIUFmfqjNzVq6UTTEZbD6/
         cq6F+gZvE/nYHjEyGeNUuF/JF95Q6/HLQv3qf/7y4paceeOPZpHl3Ev/446VWEv+B+4b
         IBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5fl4A7nRdQONkc+Ns32BwHf/X7YnX+et/nIg9JJL2zU=;
        b=B87NbZIbLKiuUTURFThhvs2SMWre10Crw9wz3hG1Bs8BKWXK3WKVm50fOqqhAiWFUl
         cB9HP0mQjRg7R+ecQlB6M9ok6+98q6OVHlFrRMXnbljFf6i6ojTWiQoH2DhfhDZ+TZO4
         q3zy61dkeJq7NBFd+LCl5RSL1e3u64sYQACr3iBnuDSFkj+dudjnW/Ks4f2Bol6kOHGv
         v8rhIAmvRMpsfm3cr7pD8RoMM7WX63ZWt+X0YzuLqF8ZpCxNA6OLoolgDIBtbZ+CFOuv
         ZUUaxE7ZJscdT0FszfJh9SlSMHYFKd0xLDO7KQw/1JmVEVtJL5n+6TVQKdWmMfJT+KbA
         xyMg==
X-Gm-Message-State: AGi0PuZnda7WPPp9FrmtYyhvgGZAUU5dNUaI33ktEiSxlWZ7rpStzno1
        SdZuZw2bEko4R3wB129TEUXCz8DdoGY=
X-Google-Smtp-Source: APiQypKEnU1zF7+eWCBcmj0qvCVqLKmZHMNFwVXoZaQrmlJkac50VlkAbDcbpHZOQ6d2aDNMPqqV1g==
X-Received: by 2002:a19:c3c5:: with SMTP id t188mr718181lff.199.1587602373144;
        Wed, 22 Apr 2020 17:39:33 -0700 (PDT)
Received: from [172.16.20.20] ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id t19sm502360lfl.53.2020.04.22.17.39.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 17:39:32 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Re: [PATCH 0/3] Bluetooth: hci_qca: add support for QCA9377
From:   Christian Hewitt <christianshewitt@gmail.com>
In-Reply-To: <D965D634-A881-43E0-B9F8-DF4679BB9C6D@holtmann.org>
Date:   Thu, 23 Apr 2020 04:39:24 +0400
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6103BC70-F2AC-4CA5-BF6F-152466AEEBD1@gmail.com>
References: <20200421081656.9067-1-christianshewitt@gmail.com>
 <D965D634-A881-43E0-B9F8-DF4679BB9C6D@holtmann.org>
To:     Marcel Holtmann <marcel@holtmann.org>
X-Mailer: Apple Mail (2.3445.104.14)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 22 Apr 2020, at 9:39 pm, Marcel Holtmann <marcel@holtmann.org> =
wrote:
>=20
> Hi Christian,
>=20
>> This series adds a new compatible for the QCA9377 BT device that is =
found
>> in many Android TV box devices, makes minor changes to allow =
max-speed
>> values for the device to be read from device-tree, and updates =
bindings
>> to reflect those changes.
>>=20
>> Christian Hewitt (3):
>> dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
>> Bluetooth: hci_qca: add compatible for QCA9377
>> Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices
>>=20
>> .../bindings/net/qualcomm-bluetooth.txt         |  5 +++++
>> drivers/bluetooth/hci_qca.c                     | 17 =
++++++++++-------
>> 2 files changed, 15 insertions(+), 7 deletions(-)
>=20
> the series doesn=E2=80=99t apply cleanly against bluetooth-next tree. =
Can you please respin it.

Ahh, it was based on 5.7-rc1, will do, thanks.

Christian=
