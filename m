Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADAB160144
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 01:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgBPAuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 19:50:14 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37067 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgBPAuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 19:50:13 -0500
Received: by mail-ot1-f67.google.com with SMTP id l2so6598927otp.4;
        Sat, 15 Feb 2020 16:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uyRNNBKtZ/pBAy6wlcISFvmc40pdoR2VRPKkepKzyLM=;
        b=Q0WMVYVIM+b2pr/Pn3tUSRAGxAZgv4nYkNxBhG9toP/WvAIaLdYxyP/EisHgN+9XtK
         cO+219jw4OkNMwxE1dme0AOosSoMn1fSVZZezJDyfLaLCP5mmKJ+B1up/4dGma5d7fcD
         R35KuDmUMpPqQVeLbfnR2tQqq0819mnmLSfQWwSaE2ZD+kOEk8SvqG0v7mZ1ShkHU/0b
         ef7TfSzPlXhbF9ibeJZ+jLq434eAPDRc7Tt93/ZyRczazQP6fIrJ7x4LJy6xnAgZXr5v
         DVfR/DdYNvvpVowKpq+XUhfgOFeD1fDdfo9bv29ZlPLmc7Ez6QBHK9xBsk/lAcmUFOEk
         ebCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uyRNNBKtZ/pBAy6wlcISFvmc40pdoR2VRPKkepKzyLM=;
        b=b+OF5cWF1xEtNNlVKUh6+EI79Jd3sirBzooN/6LZDWMMjI/3qAr9iq0kVBvgUo7xUa
         AjhcObNZo0dxpXVNbQs6L5gucvT0tGBfMcfX2pDRwIylmI5He5iZzjOW+zOqw5sdeM39
         vyOt7mE8vd2bOCT29NV/gAjGK3tg8wxYTAPssIZc/2LdOuAgW5PDe/moUyW9ZzHnIfRA
         zJzKDZ+sm4BIfVCWqV2fe3oCLS5UTVs249trhI81pBqjWf8pErp14m6ih3mEn8zx4G2O
         YKzHP3ZL8/ROhDLWwJ6Qg0XhDxDutuPXNHN440ghn98kNkBqhYrWByBIFNr5mz4guSXt
         yyYg==
X-Gm-Message-State: APjAAAVI9nypy+HvWwLk+wovsqI+9bKhsSwuI0fbY0puO2+wswRzuj5X
        MK37TY5MJ0Oymf1P7AHLbV9pmIm5
X-Google-Smtp-Source: APXvYqw24cLn9pSDb30se6fd1ilKzuFGImR7J+NkDrn/Y/GrxMH5sclpTk/kehtaW2O3M77GOCbRMA==
X-Received: by 2002:a05:6830:138b:: with SMTP id d11mr7101057otq.38.1581814212513;
        Sat, 15 Feb 2020 16:50:12 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id g25sm3678506otr.8.2020.02.15.16.50.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 15 Feb 2020 16:50:11 -0800 (PST)
Date:   Sat, 15 Feb 2020 17:50:10 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [Bluez PATCH v5] bluetooth: secure bluetooth stack from bluedump
 attack
Message-ID: <20200216005010.GA24335@ubuntu-m2-xlarge-x86>
References: <20200214191609.Bluez.v5.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214191609.Bluez.v5.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

On Fri, Feb 14, 2020 at 07:16:41PM +0800, Howard Chung wrote:
> Attack scenario:
> 1. A Chromebook (let's call this device A) is paired to a legitimate
>    Bluetooth classic device (e.g. a speaker) (let's call this device
>    B).
> 2. A malicious device (let's call this device C) pretends to be the
>    Bluetooth speaker by using the same BT address.
> 3. If device A is not currently connected to device B, device A will
>    be ready to accept connection from device B in the background
>    (technically, doing Page Scan).
> 4. Therefore, device C can initiate connection to device A
>    (because device A is doing Page Scan) and device A will accept the
>    connection because device A trusts device C's address which is the
>    same as device B's address.
> 5. Device C won't be able to communicate at any high level Bluetooth
>    profile with device A because device A enforces that device C is
>    encrypted with their common Link Key, which device C doesn't have.
>    But device C can initiate pairing with device A with just-works
>    model without requiring user interaction (there is only pairing
>    notification). After pairing, device A now trusts device C with a
>    new different link key, common between device A and C.
> 6. From now on, device A trusts device C, so device C can at anytime
>    connect to device A to do any kind of high-level hijacking, e.g.
>    speaker hijack or mouse/keyboard hijack.
> 
> Since we don't know whether the repairing is legitimate or not,
> leave the decision to user space if all the conditions below are met.
> - the pairing is initialized by peer
> - the authorization method is just-work
> - host already had the link key to the peer
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> 
> Changes in v5:
> - Rephrase the comment
> 
> Changes in v4:
> - optimise the check in smp.c.
> 
> Changes in v3:
> - Change confirm_hint from 2 to 1
> - Fix coding style (declaration order)
> 
> Changes in v2:
> - Remove the HCI_PERMIT_JUST_WORK_REPAIR debugfs option
> - Fix the added code in classic
> - Add a similar fix for LE
> 
>  net/bluetooth/hci_event.c | 10 ++++++++++
>  net/bluetooth/smp.c       | 19 +++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 2c833dae9366..e6982f4f51ea 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4571,6 +4571,16 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
>  			goto confirm;
>  		}
>  
> +		/* If there already exists link key in local host, leave the
> +		 * decision to user space since the remote device could be
> +		 * legitimate or malicious.
> +		 */
> +		if (hci_find_link_key(hdev, &ev->bdaddr)) {
> +			bt_dev_warn(hdev, "Local host already has link key");
> +			confirm_hint = 1;
> +			goto confirm;
> +		}
> +
>  		BT_DBG("Auto-accept of user confirmation with %ums delay",
>  		       hdev->auto_accept_delay);
>  
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 2cba6e07c02b..25dbf77d216b 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -2192,6 +2192,25 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
>  		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
>  			     smp->prnd);
>  		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
> +
> +		/* Only Just-Works pairing requires extra checks */
> +		if (smp->method != JUST_WORKS)
> +			goto mackey_and_ltk;
> +
> +		/* If there already exists link key in local host, leave the
> +		 * decision to user space since the remote device could be
> +		 * legitimate or malicious.
> +		 */
> +		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
> +				 hcon->role)) {
> +			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> +							hcon->type,
> +							hcon->dst_type, passkey,

We received a report from the 0day bot when building with clang that
passkey is uninitialized when used here:

https://groups.google.com/forum/#!topic/clang-built-linux/kyRKCjRsGoU

It appears to be legitimate as if we get to this point, we have not
touched the value of passkey but I do not know if there is any
contextual code flow going on where this can never happen but I do not
see how.

Would you mind looking into it?

Cheers,
Nathan
