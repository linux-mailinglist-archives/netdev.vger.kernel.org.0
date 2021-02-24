Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7D43236D5
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 06:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhBXFZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 00:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhBXFZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 00:25:13 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4D4C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 21:24:33 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id g4so456959vsb.11
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 21:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2XGXmghpVFaqV4oPOsoKIqOsEMBDaJOqUvfO+0/qM0=;
        b=RVFq+CyvdYZIQXKr35YZLF/+JGhdnda45nWPtkt3gwRcMCJW2Ppgs1mxvMJ90Ae6Dr
         rkHmPZ9Iyl/RJnTz9tN6IYIonBD6qZTj30fzRl38zUtGSPw5eL5XodxJk79GKipqNdmb
         lEuBPh8oXSWnt/IwQGRubm3Lo2FV5e9E3YO+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2XGXmghpVFaqV4oPOsoKIqOsEMBDaJOqUvfO+0/qM0=;
        b=ueJEhqO2IjQvy8zjMmgUcMCVjGNgO6D9YrcQvylw+DSYX0s/s6v5Cavw2J2dnTiH0O
         Vz1NwSxZpOTA7kTqDQUhBbgOfzWKiJoPVB2CzOK5ZYCpZq9zApWywceEb4zLe7jpNNFa
         NWt2Q7KAxESlTSj26wJzSSQ5S8nCzLQ/AIvEiE9h7Mx1jYBDoZGPJ7AmaD4xmmIrXddX
         VB+38clKM4IsJd3UhQ2nQbObMCqCybzimDuGuP6JGyj8siifsX7gHe56c7PMIv9uC0kp
         G0C6Wpo3e/rqtMTJ/jvKYT2gD4WAbJ5S4P5BOWOLXmZi0pQYyKZ9BuXKJKXrwlfdn/gi
         Fxsw==
X-Gm-Message-State: AOAM531cdjUEwkKXKr6psEBbMAZUqyjiPdZFGBu8QQEf/oz9klYUO1qR
        PZVkRA8le+CEtD7Irl5qgcZKhXeJLQmN2Zmdt/KiCPP7TCt3N56m
X-Google-Smtp-Source: ABdhPJzEAbkIX9BtIoR4ynxQ804ZDwUKtd8fbEwlta3G03qStU/y5cICVudtM3EoQa9SLp6/NijDlLFoE657mIWcgE4=
X-Received: by 2002:a05:6102:ac2:: with SMTP id m2mr3322940vsh.52.1614144271813;
 Tue, 23 Feb 2021 21:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20210218102038.2996-1-oneukum@suse.com> <20210218102038.2996-4-oneukum@suse.com>
 <CANEJEGvsYPmnxx2sV89aLPJzK_SgWEW8FPhgo2zNk2d5zijK2Q@mail.gmail.com> <8cd8ba7cfd3d2db647c48224063122fb865574bb.camel@suse.com>
In-Reply-To: <8cd8ba7cfd3d2db647c48224063122fb865574bb.camel@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Wed, 24 Feb 2021 05:24:20 +0000
Message-ID: <CANEJEGu1bQCvONN87b+E6PrTuZoA1A0ts9q+x-Uux1gAy-bAvg@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] CDC-NCM: record speed in status method
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.org, Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: multipart/mixed; boundary="000000000000f0ccdd05bc0e3f00"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f0ccdd05bc0e3f00
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, Feb 22, 2021 at 10:14 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> Am Freitag, den 19.02.2021, 07:30 +0000 schrieb Grant Grundler:
> > On Thu, Feb 18, 2021 at 10:21 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> Hi,
>
> > Since this patch is missing the hunks that landed in the previous
> > patch and needs a v4, I'll offer my version of the commit message in
>
> That is bad. I will have to search for that.

No worries - it happens. To make this easier for you, let me point out
what I've observed.

I just noticed there are two hunks that landed in the wrong (posted) patches.

1) In "[PATCHv3 2/3] usbnet: add method for reporting speed without
MDIO", this hunk is "repairing" the part that failed to build for
Jakub:

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index f3e5ad9befd0..368428a4290b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -971,10 +971,10 @@ int usbnet_get_link_ksettings_internal(struct
net_device *net,
         * For wireless stuff it is not true.
         * We assume that rxspeed matters more.
         */
-       if (dev->rxspeed != SPEED_UNKNOWN)
-               cmd->base.speed = dev->rxspeed / 1000000;
-       else if (dev->txspeed != SPEED_UNKNOWN)
-               cmd->base.speed = dev->txspeed / 1000000;
+       if (dev->rx_speed != SPEED_UNSET)
+               cmd->base.speed = dev->rx_speed / 1000000;
+       else if (dev->tx_speed != SPEED_UNSET)
+               cmd->base.speed = dev->tx_speed / 1000000;
        else
                cmd->base.speed = SPEED_UNKNOWN;

Just this hunk should have been folded into the previous patch:
"[PATCHv3 1/3] usbnet: specify naming of
usbnet_set/get_link_ksettings"

2) "[PATCHv3 1/3]" has the hunk to override .get_link_ksettings and
.set_link_ksettings fields for cdc_ncm.c:
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 4087c9e33781..0d26cbeb6e04 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -142,8 +142,8 @@ static const struct ethtool_ops cdc_ncm_ethtool_ops = {
        .get_sset_count    = cdc_ncm_get_sset_count,
        .get_strings       = cdc_ncm_get_strings,
        .get_ethtool_stats = cdc_ncm_get_ethtool_stats,
-       .get_link_ksettings      = usbnet_get_link_ksettings,
-       .set_link_ksettings      = usbnet_set_link_ksettings,
+       .get_link_ksettings      = usbnet_get_link_ksettings_internal,
+       .set_link_ksettings      = usbnet_set_link_ksettings_mii,
 };

This hunk should have been included in "[PATCHv3 3/3] CDC-NCM: record
speed in status method" (email thread I'm replying to).

Also, I believe this hunk is incorrect: .set_link_ksettings should be
set to NULL since speed can't be changed by cdc_ncm driver (AFAIK).


Swap around where those hunks landed and you'll be golden. :)

> > case you like it better:
>
> Something written by a native speaker with knowledge in the field is
> always better.

"knowledge in the field" sounds quite generous. I'll claim I
understand this particular problem reasonably well. :)

> I will take it, wait two weeks and then resubmit.

Excellent!

Just to be clear, I'm understanding you will resubmit next week. SGTM.

Also, please add the cdc_ether patch (attached) to the series (since
it depends on the work you are doing). Andrew Lunn
also expected cdc_ether to be updated in the same series (in reply to
"[PATCHv2 0/3] usbnet: speed reporting...").

cheers,
grant

--000000000000f0ccdd05bc0e3f00
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-net-cdc_ether-record-speed-in-status-method.patch"
Content-Disposition: attachment; 
	filename="0001-net-cdc_ether-record-speed-in-status-method.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kliysdl10>
X-Attachment-Id: f_kliysdl10

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
--000000000000f0ccdd05bc0e3f00--
