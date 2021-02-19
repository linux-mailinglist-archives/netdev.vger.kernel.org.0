Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD0B31F56A
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 08:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBSHoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 02:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBSHoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 02:44:22 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D683AC061574
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 23:43:41 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id l19so2260351vso.8
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 23:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWo3QV11qLYhaCtzZBxTNU7NoOHSmOxb1tC+NLefoOc=;
        b=eXXwMLg9EVbN8lac9XRACJv1VTSeYya6MqK5Tr7B0yj0bwpK3RN1CfcRpTLWP4R7KR
         43P7giSVNj0n0BV6sLvQ0dwxjuCbncyzvTiyekZLtNCvvp6npnU+2QQX3CdEYVtfA1j8
         VyvsUQnnJnBIJaLmE653aD1iZDV+sh21IFq+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWo3QV11qLYhaCtzZBxTNU7NoOHSmOxb1tC+NLefoOc=;
        b=apKUofwrLUCT68a0Bq5X3sjqg/Kt5HyHr6oxUgZokBnSigmAYYR9GiZtis3cw4QPb9
         kpylXDv1lHbLpyk80wmYFgebF/9mbeh5rh3KnAV3FFWlB2JfJSAHc9lb7kWZiVrrszbZ
         iDtKah3SzIEXwNmFammvre9KQW+5FWf44R6lTsYgvhkYj0qoXl5DpJCTW9HEkA3QIbzd
         aVtpoQqpZ67xcRXwZGh5SwSljv0UuLECY+n6aFGNzfZaKSQDzXqQ14ggtOYRAkkWWeyv
         TCshG1CKi3l6Jg2ircMoWE1+36LNdGgS/ChWtpZUleg58r5H6mcnHWOwJ3+l6bE1msAl
         m+zA==
X-Gm-Message-State: AOAM533u+GCtXia86wt5os7eHproS++oHaS2WNA+v1oYUf8O1rgFXs7w
        aEpp52kOLvu1QaHx/WrD9VC67CvWAF3O+8qGBGF5qHMcTbImtA==
X-Google-Smtp-Source: ABdhPJzqXFftekmdITP8wGxYBH9WQ+tTE0D5iC/guaK1owyzd578BQRZoGHwLszTr53DVeKivlbkbIALqAAY+xUj4wE=
X-Received: by 2002:a67:6e83:: with SMTP id j125mr4356083vsc.2.1613720620674;
 Thu, 18 Feb 2021 23:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20210218102038.2996-1-oneukum@suse.com> <20210218102038.2996-4-oneukum@suse.com>
In-Reply-To: <20210218102038.2996-4-oneukum@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 19 Feb 2021 07:43:28 +0000
Message-ID: <CANEJEGu6q+JNbeX9=h1NQHYQCm4xevua=84oVnKgR8jmUMQnTQ@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] CDC-NCM: record speed in status method
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>, davem@davemloft.org,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: multipart/mixed; boundary="0000000000005daa7705bbab9c63"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005daa7705bbab9c63
Content-Type: text/plain; charset="UTF-8"

Oliver,
Can you include a 4th patch in the series to bring cdc_ether driver in
line with the cdc_ncm behavior?

I apologize for not including the patch inline - but it's late and I
don't want to fight with gmail at this point. Patch is attached. Not
tested.

cheers,
grant

On Thu, Feb 18, 2021 at 10:21 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> The driver has a status method for receiving speed updates.
> The framework, however, had support functions only for devices
> that reported their speed upon an explicit query over a MDIO
> interface.
> CDC_NCM however gets direct notifications from the device.
> As new support functions have become available, we shall now
> record such notifications and tell the usbnet framework
> to make direct use of them without going through the PHY layer.
>
> v2: rebased on upstream
> v3: changed variable names
>
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 23 +----------------------
>  1 file changed, 1 insertion(+), 22 deletions(-)
>
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 0d26cbeb6e04..74c1a86b1a71 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1829,30 +1829,9 @@ cdc_ncm_speed_change(struct usbnet *dev,
>         uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
>         uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
>
> -       /* if the speed hasn't changed, don't report it.
> -        * RTL8156 shipped before 2021 sends notification about every 32ms.
> -        */
> -       if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
> -               return;
> -
> +        /* RTL8156 shipped before 2021 sends notification about every 32ms. */
>         dev->rx_speed = rx_speed;
>         dev->tx_speed = tx_speed;
> -
> -       /*
> -        * Currently the USB-NET API does not support reporting the actual
> -        * device speed. Do print it instead.
> -        */
> -       if ((tx_speed > 1000000) && (rx_speed > 1000000)) {
> -               netif_info(dev, link, dev->net,
> -                          "%u mbit/s downlink %u mbit/s uplink\n",
> -                          (unsigned int)(rx_speed / 1000000U),
> -                          (unsigned int)(tx_speed / 1000000U));
> -       } else {
> -               netif_info(dev, link, dev->net,
> -                          "%u kbit/s downlink %u kbit/s uplink\n",
> -                          (unsigned int)(rx_speed / 1000U),
> -                          (unsigned int)(tx_speed / 1000U));
> -       }
>  }
>
>  static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
> --
> 2.26.2
>

--0000000000005daa7705bbab9c63
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-net-cdc_ether-record-speed-in-status-method.patch"
Content-Disposition: attachment; 
	filename="0001-net-cdc_ether-record-speed-in-status-method.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_klbzisv00>
X-Attachment-Id: f_klbzisv00

RnJvbSBlNWFjNTI4YzA4YmIzNWIyNWNiYmY5YTVlOTFkMjQ5MTEwMGU2NzYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHcmFudCBHcnVuZGxlciA8R3JhbnQgR3J1bmRsZXIgZ3J1bmRs
ZXJAY2hyb21pdW0ub3JnPgpEYXRlOiBXZWQsIDE3IEZlYiAyMDIxIDIwOjU1OjU3IC0wODAwClN1
YmplY3Q6IFtQQVRDSF0gbmV0OiBjZGNfZXRoZXI6IHJlY29yZCBzcGVlZCBpbiBzdGF0dXMgbWV0
aG9kCgpVbnRpbCB2ZXJ5IHJlY2VudGx5LCB0aGUgdXNibmV0IGZyYW1ld29yayBvbmx5IGhhZCBz
dXBwb3J0IGZ1bmN0aW9ucwpmb3IgZGV2aWNlcyB3aGljaCByZXBvcnRlZCB0aGUgbGluayBzcGVl
ZCBieSBleHBsaWNpdGx5IHF1ZXJ5aW5nIHRoZQpQSFkgb3ZlciBhIE1ESU8gaW50ZXJmYWNlLiBI
b3dldmVyLCB0aGUgY2RjX2V0aGVyIGRldmljZXMgc2VuZApub3RpZmljYXRpb25zIHdoZW4gdGhl
IGxpbmsgc3RhdGUgb3IgbGluayBzcGVlZHMgY2hhbmdlIGFuZCBkbyBub3QKZXhwb3NlIHRoZSBQ
SFkgKG9yIG1vZGVtKSBkaXJlY3RseS4KClN1cHBvcnQgZnVudGlvbnMgKGUuZy4gdXNibmV0X2dl
dF9saW5rX2tzZXR0aW5nc19pbnRlcm5hbCgpKSB0byBkaXJlY3RseQpxdWVyeSBzdGF0ZSByZWNv
cmRlZCBieSB0aGUgY2RjX2V0aGVyIGRyaXZlciB3ZXJlIGFkZGVkIGluIGEgcHJldmlvdXMgcGF0
Y2guCgpTbyBpbnN0ZWFkIG9mIGNkY19ldGhlciBzcGV3aW5nIHRoZSBsaW5rIHNwZWVkIGludG8g
dGhlIGRtZXNnIGJ1ZmZlciwKcmVjb3JkIHRoZSBsaW5rIHNwZWVkIGVuY29kZWQgaW4gdGhlc2Ug
bm90aWZpY2F0aW9ucyBhbmQgdGVsbCB0aGUKdXNibmV0IGZyYW1ld29yayB0byB1c2UgdGhlIG5l
dyBmdW5jdGlvbnMgdG8gZ2V0IGxpbmsgc3BlZWQvc3RhdGUuCgpTaWduZWQtb2ZmLWJ5OiBHcmFu
dCBHcnVuZGxlciA8Z3J1bmRsZXJAY2hyb21pdW0ub3JnPgotLS0KIGRyaXZlcnMvbmV0L3VzYi9j
ZGNfZXRoZXIuYyB8IDI3ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDIwIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvdXNiL2NkY19ldGhlci5jIGIvZHJpdmVycy9uZXQvdXNiL2NkY19ldGhlci5jCmluZGV4
IGE5YjU1MTAyODY1OS4uZTEzZTliNzk5NDMyIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC91c2Iv
Y2RjX2V0aGVyLmMKKysrIGIvZHJpdmVycy9uZXQvdXNiL2NkY19ldGhlci5jCkBAIC05Miw2ICs5
MiwxOCBAQCB2b2lkIHVzYm5ldF9jZGNfdXBkYXRlX2ZpbHRlcihzdHJ1Y3QgdXNibmV0ICpkZXYp
CiB9CiBFWFBPUlRfU1lNQk9MX0dQTCh1c2JuZXRfY2RjX3VwZGF0ZV9maWx0ZXIpOwogCisvKiBX
ZSBuZWVkIHRvIG92ZXJyaWRlIHVzYm5ldF8qX2xpbmtfa3NldHRpbmdzIGluIGJpbmQoKSAqLwor
c3RhdGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBjZGNfZXRoZXJfZXRodG9vbF9vcHMgPSB7
CisJLmdldF9saW5rCQk9IHVzYm5ldF9nZXRfbGluaywKKwkubndheV9yZXNldAkJPSB1c2JuZXRf
bndheV9yZXNldCwKKwkuZ2V0X2RydmluZm8JCT0gdXNibmV0X2dldF9kcnZpbmZvLAorCS5nZXRf
bXNnbGV2ZWwJCT0gdXNibmV0X2dldF9tc2dsZXZlbCwKKwkuc2V0X21zZ2xldmVsCQk9IHVzYm5l
dF9zZXRfbXNnbGV2ZWwsCisJLmdldF90c19pbmZvCQk9IGV0aHRvb2xfb3BfZ2V0X3RzX2luZm8s
CisJLmdldF9saW5rX2tzZXR0aW5ncwk9IHVzYm5ldF9nZXRfbGlua19rc2V0dGluZ3NfaW50ZXJu
YWwsCisJLnNldF9saW5rX2tzZXR0aW5ncwk9IE5VTEwsCit9OworCiAvKiBwcm9iZXMgY29udHJv
bCBpbnRlcmZhY2UsIGNsYWltcyBkYXRhIGludGVyZmFjZSwgY29sbGVjdHMgdGhlIGJ1bGsKICAq
IGVuZHBvaW50cywgYWN0aXZhdGVzIGRhdGEgaW50ZXJmYWNlIChpZiBuZWVkZWQpLCBtYXliZSBz
ZXRzIE1UVS4KICAqIGFsbCBwdXJlIGNkYywgZXhjZXB0IGZvciBjZXJ0YWluIGZpcm13YXJlIHdv
cmthcm91bmRzLCBhbmQga25vd2luZwpAQCAtMzEwLDYgKzMyMiw5IEBAIGludCB1c2JuZXRfZ2Vu
ZXJpY19jZGNfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCB1c2JfaW50ZXJmYWNlICpp
bnRmKQogCQlyZXR1cm4gLUVOT0RFVjsKIAl9CiAKKwkvKiBvdmVycmlkZSBldGh0b29sX29wcyAq
LworCWRldi0+bmV0LT5ldGh0b29sX29wcyA9ICZjZGNfZXRoZXJfZXRodG9vbF9vcHM7CisKIAly
ZXR1cm4gMDsKIAogYmFkX2Rlc2M6CkBAIC0zNzksMTIgKzM5NCwxMCBAQCBFWFBPUlRfU1lNQk9M
X0dQTCh1c2JuZXRfY2RjX3VuYmluZCk7CiAgKiAoYnkgQnJhZCBIYXJkcykgdGFsa2VkIHdpdGgs
IHdpdGggbW9yZSBmdW5jdGlvbmFsaXR5LgogICovCiAKLXN0YXRpYyB2b2lkIGR1bXBzcGVlZChz
dHJ1Y3QgdXNibmV0ICpkZXYsIF9fbGUzMiAqc3BlZWRzKQorc3RhdGljIHZvaWQgc3BlZWRfY2hh
bmdlKHN0cnVjdCB1c2JuZXQgKmRldiwgX19sZTMyICpzcGVlZHMpCiB7Ci0JbmV0aWZfaW5mbyhk
ZXYsIHRpbWVyLCBkZXYtPm5ldCwKLQkJICAgImxpbmsgc3BlZWRzOiAldSBrYnBzIHVwLCAldSBr
YnBzIGRvd25cbiIsCi0JCSAgIF9fbGUzMl90b19jcHUoc3BlZWRzWzBdKSAvIDEwMDAsCi0JCSAg
IF9fbGUzMl90b19jcHUoc3BlZWRzWzFdKSAvIDEwMDApOworCWRldi0+dHhfc3BlZWQgPSBfX2xl
MzJfdG9fY3B1KHNwZWVkc1swXSk7CisJZGV2LT5yeF9zcGVlZCA9IF9fbGUzMl90b19jcHUoc3Bl
ZWRzWzFdKTsKIH0KIAogdm9pZCB1c2JuZXRfY2RjX3N0YXR1cyhzdHJ1Y3QgdXNibmV0ICpkZXYs
IHN0cnVjdCB1cmIgKnVyYikKQEAgLTM5Niw3ICs0MDksNyBAQCB2b2lkIHVzYm5ldF9jZGNfc3Rh
dHVzKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHVyYiAqdXJiKQogCiAJLyogU1BFRURfQ0hB
TkdFIGNhbiBnZXQgc3BsaXQgaW50byB0d28gOC1ieXRlIHBhY2tldHMgKi8KIAlpZiAodGVzdF9h
bmRfY2xlYXJfYml0KEVWRU5UX1NUU19TUExJVCwgJmRldi0+ZmxhZ3MpKSB7Ci0JCWR1bXBzcGVl
ZChkZXYsIChfX2xlMzIgKikgdXJiLT50cmFuc2Zlcl9idWZmZXIpOworCQlzcGVlZF9jaGFuZ2Uo
ZGV2LCAoX19sZTMyICopIHVyYi0+dHJhbnNmZXJfYnVmZmVyKTsKIAkJcmV0dXJuOwogCX0KIApA
QCAtNDEzLDcgKzQyNiw3IEBAIHZvaWQgdXNibmV0X2NkY19zdGF0dXMoc3RydWN0IHVzYm5ldCAq
ZGV2LCBzdHJ1Y3QgdXJiICp1cmIpCiAJCWlmICh1cmItPmFjdHVhbF9sZW5ndGggIT0gKHNpemVv
ZigqZXZlbnQpICsgOCkpCiAJCQlzZXRfYml0KEVWRU5UX1NUU19TUExJVCwgJmRldi0+ZmxhZ3Mp
OwogCQllbHNlCi0JCQlkdW1wc3BlZWQoZGV2LCAoX19sZTMyICopICZldmVudFsxXSk7CisJCQlz
cGVlZF9jaGFuZ2UoZGV2LCAoX19sZTMyICopICZldmVudFsxXSk7CiAJCWJyZWFrOwogCS8qIFVT
Ql9DRENfTk9USUZZX1JFU1BPTlNFX0FWQUlMQUJMRSBjYW4gaGFwcGVuIHRvbyAoZS5nLiBSTkRJ
UyksCiAJICogYnV0IHRoZXJlIGFyZSBubyBzdGFuZGFyZCBmb3JtYXRzIGZvciB0aGUgcmVzcG9u
c2UgZGF0YS4KLS0gCjIuMzAuMAoK
--0000000000005daa7705bbab9c63--
