Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D88194F4C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgC0C70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:59:26 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:38300 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0C70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:59:26 -0400
Received: by mail-vk1-f193.google.com with SMTP id n128so2314518vke.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 19:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=efTQZuBY/BdGfCfIti/x+eiTAFDqkj9PxcQRTVTmyvU=;
        b=PN5kNO2Y7Hatz8rIRcoPnXIU8mrZax4gEuaM4gYGUvAR0T+yaNwxlUB4HxBPh8/tJD
         QlaJ57p+hjcFxR3Hce0XwoA+X/KiThWplYxgAGee7iJHAFxDwY2d0ahgVf7D6aC4uXWd
         8u7hA7WRnVXCv44NGJxiFFZWUulBbnxQe1yXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=efTQZuBY/BdGfCfIti/x+eiTAFDqkj9PxcQRTVTmyvU=;
        b=cQlRupukPdcDZa75i4bjFtZJ4Y4CQ2M3iu2rTvMt5RHbOkWbd3y19zpmW1kVeBu7gE
         NXNKPBNRKeM5rsRHSeN3lF6fLc5xsZ2VwaNqtPRv0bpwH94AQ331OIgMck1xkqTDWe5c
         fy23emQiawAT4NWrJrLNjgItBxqBrIpuMbKpvRsQ8+ZzMQhpuD3obSz2EJfUbUQ8/5ij
         ytDtx5YxHFYC4Dxq06bsfqwqZOQIOhlJD3MKsd4duK9aC88/zEgSfRH7hqYmPMIJ5ncA
         Vvd38ETornQ1hQ080LgtevVSIqxvXs+Cymdt+nCVUXtnhGWlL1nJR2qJnHy402xOTc9u
         CKNg==
X-Gm-Message-State: ANhLgQ3ETf50I374xAviamj0HVDjaYM/T5Zfhr6SqFcNRc6lLswkmHS1
        dMzQF/b/VXG4PmMESiDfpl/q9CBVBnatymXSuUTfAw==
X-Google-Smtp-Source: ADFU+vuZLKGOnsm6OEMlUxXQh1lnoHRPEGsoLXro6EVkvPJIkztcCUU1ETtAxDELD2TaI4PY1Ozcxx+NYyavz8ak7SI=
X-Received: by 2002:a1f:2706:: with SMTP id n6mr4191470vkn.88.1585277964583;
 Thu, 26 Mar 2020 19:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200326054517.71462-1-abhishekpandit@chromium.org>
In-Reply-To: <20200326054517.71462-1-abhishekpandit@chromium.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Thu, 26 Mar 2020 19:59:11 -0700
Message-ID: <CANFp7mX3VhgbqSixv9BtWU5C4xy0RGqyPfV5SmruyngkkjM-VA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] Bluetooth: Add actions to set wakeable in add device
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

Does this look ok? I'm working on the accompanying Bluez changes as
well and will send a new patch if the mgmt changes look ok.

Thanks
Abhishek

On Wed, Mar 25, 2020 at 10:45 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
>
> Hi Marcel,
>
> As suggested, I've updated add device to accept action 0x3 and 0x4 to
> set and remove the wakeable property.
>
> Thanks
> Abhishek
>
>
> Changes in v2:
> * Added missing goto unlock
>
> Abhishek Pandit-Subedi (1):
>   Bluetooth: Update add_device with wakeable actions
>
>  net/bluetooth/mgmt.c | 57 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 47 insertions(+), 10 deletions(-)
>
> --
> 2.25.1.696.g5e7596f4ac-goog
>
