Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3783E21BDA
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfEQQmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 12:42:32 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38487 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfEQQmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 12:42:32 -0400
Received: by mail-it1-f196.google.com with SMTP id i63so13026066ita.3;
        Fri, 17 May 2019 09:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=90mT8/yiktCbDeTFNhEhmXUY3umlcFdq4eEDvU0Lx3E=;
        b=pXJEI0b1J90n8oxpF2QER9zCAFXBiDNzIL55uU/0Y91Ja3JKKQQrgKPuAtub/SP+xs
         42Ua7NzjM5JiiiWjqyuS4z4mnxNsu9A7lU6aZHr09fcRsI3jRy+ibRXHKb9bT+aPBBzs
         4vdQ83eTzv/Q0sV3UsmYXIcJrKNbYgSoskClpG3S2aoX2Q0La1EuQA/y8p3uNDMoZJ/w
         GaK3aM1VTKybemPTVKChdYfRVdKnA6n+P+VmmqH8FdgLzlNGchdnl/IQnniQRNG1x+xN
         yW2ld5ZNMGqOTY9ei/yvb5J1SgSYsYBzOgbsOvGvNnV1zZKvDwQR8xfgIzeBk4VQktQ3
         Dxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90mT8/yiktCbDeTFNhEhmXUY3umlcFdq4eEDvU0Lx3E=;
        b=Uh3/4J8EBK4DQmkfkTfv1pTUfXeguUCF/7sSVRNGvsLjxZqMUODRji1XSZ9EGTzaSW
         U4d4BfDuiists30oLSjAsvaITNe0Va+r2+KILYh8DbeSq05TJajzMDomBemsOZ2bik5f
         Sw2FNQrxieUstNAizFLETozANh4QeW8rCbIF6KuhymVHu70/8EZMZz2tkyP9uaaubk3C
         BqKpowvNPFmS28/Q5bBJd/ypEW3+zSTubT97QRm8ZLj4xQfXz6fH8d9GqMu7x8abCsiH
         BovYQesx44eTfzmKEr/WijaIdYv+rdE4ALrDGD+R9SueVicH12PxhFVBB16fY8ijCaxn
         eq0Q==
X-Gm-Message-State: APjAAAXqARR/WX4X9ji8bGJwbCGqnY4yTqPWYvIATzv3ZZ5MKRnO5A+T
        WvZa4qJ3V+eKWl9t6/D7CVN6rSIFy+whnHo/+DI=
X-Google-Smtp-Source: APXvYqxPl6t//pqd9Lb4lBgBl8S4KfnakS9+doE5DeI7YpJxTrLVvKwr2Syc26OeLGd5iX6EsAbVtkvjulFfaAyelqk=
X-Received: by 2002:a24:d145:: with SMTP id w66mr3299197itg.71.1558111351074;
 Fri, 17 May 2019 09:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
 <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca> <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
 <20190503205935.bg45rsso5jjj3gnx@csclub.uwaterloo.ca> <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
 <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
 <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca> <CAKgT0UdPDyCBsShQVwwE5C8fBKkMcfS6_S5m3T7JP-So9fzVgA@mail.gmail.com>
 <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca> <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
 <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
In-Reply-To: <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 17 May 2019 09:42:19 -0700
Message-ID: <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: multipart/mixed; boundary="0000000000009a0fcd0589181114"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009a0fcd0589181114
Content-Type: text/plain; charset="UTF-8"

On Thu, May 16, 2019 at 4:32 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, May 16, 2019 at 11:37 AM Lennart Sorensen
> <lsorense@csclub.uwaterloo.ca> wrote:
> >
> > On Thu, May 16, 2019 at 02:34:08PM -0400, Lennart Sorensen wrote:
> > > Here is what I see:
> > >
> > > i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
> > > i40e: Copyright (c) 2013 - 2014 Intel Corporation.
> > > i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> > > i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> > > i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
> > > i40e 0000:3d:00.0: flow_type: 63 input_mask:0x0000000000004000
> > > i40e 0000:3d:00.0: flow_type: 46 input_mask:0x0007fff800000000
> > > i40e 0000:3d:00.0: flow_type: 45 input_mask:0x0007fff800000000
> > > i40e 0000:3d:00.0: flow_type: 44 input_mask:0x0007ffff80000000
> > > i40e 0000:3d:00.0: flow_type: 43 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.0: flow_type: 42 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.0: flow_type: 41 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.0: flow_type: 40 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.0: flow_type: 39 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.0: flow_type: 36 input_mask:0x0006060000000000
> > > i40e 0000:3d:00.0: flow_type: 35 input_mask:0x0006060000000000
> > > i40e 0000:3d:00.0: flow_type: 34 input_mask:0x0006060780000000
> > > i40e 0000:3d:00.0: flow_type: 33 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.0: flow_type: 32 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.0: flow_type: 31 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.0: flow_type: 30 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.0: flow_type: 29 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.0: Features: PF-id[0] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> > > i40e 0000:3d:00.1: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> > > i40e 0000:3d:00.1: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> > > i40e 0000:3d:00.1: MAC address: a4:bf:01:4e:0c:88
> > > i40e 0000:3d:00.1: flow_type: 63 input_mask:0x0000000000004000
> > > i40e 0000:3d:00.1: flow_type: 46 input_mask:0x0007fff800000000
> > > i40e 0000:3d:00.1: flow_type: 45 input_mask:0x0007fff800000000
> > > i40e 0000:3d:00.1: flow_type: 44 input_mask:0x0007ffff80000000
> > > i40e 0000:3d:00.1: flow_type: 43 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.1: flow_type: 42 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.1: flow_type: 41 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.1: flow_type: 40 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.1: flow_type: 39 input_mask:0x0007fffe00000000
> > > i40e 0000:3d:00.1: flow_type: 36 input_mask:0x0006060000000000
> > > i40e 0000:3d:00.1: flow_type: 35 input_mask:0x0006060000000000
> > > i40e 0000:3d:00.1: flow_type: 34 input_mask:0x0006060780000000
> > > i40e 0000:3d:00.1: flow_type: 33 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.1: flow_type: 32 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.1: flow_type: 31 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.1: flow_type: 30 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.1: flow_type: 29 input_mask:0x0006060600000000
> > > i40e 0000:3d:00.1: Features: PF-id[1] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> > > i40e 0000:3d:00.1 eth2: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None
> > > i40e_ioctl: power down: eth1
> > > i40e_ioctl: power down: eth2
> >
> > Those last two lines is something I added, so ignore those.
>
> No problem.
>
> So just looking at the data provided I am going to guess that IPv6 w/
> UDP likely works without any issues and it is just going to be IPv4
> that is the problem. When you compare the UDP setup from mine versus
> yours it looks like for some reason somebody swapped around the input
> bits for the L3 src and destination fields. I'm basing that on the
> input set masks in the i40e_txrx.h header:
> /* INPUT SET MASK for RSS, flow director, and flexible payload */
> #define I40E_L3_SRC_SHIFT               47
> #define I40E_L3_SRC_MASK                (0x3ULL << I40E_L3_SRC_SHIFT)
> #define I40E_L3_V6_SRC_SHIFT            43
> #define I40E_L3_V6_SRC_MASK             (0xFFULL << I40E_L3_V6_SRC_SHIFT)
> #define I40E_L3_DST_SHIFT               35
> #define I40E_L3_DST_MASK                (0x3ULL << I40E_L3_DST_SHIFT)
> #define I40E_L3_V6_DST_SHIFT            35
> #define I40E_L3_V6_DST_MASK             (0xFFULL << I40E_L3_V6_DST_SHIFT)
> #define I40E_L4_SRC_SHIFT               34
> #define I40E_L4_SRC_MASK                (0x1ULL << I40E_L4_SRC_SHIFT)
> #define I40E_L4_DST_SHIFT               33
> #define I40E_L4_DST_MASK                (0x1ULL << I40E_L4_DST_SHIFT)
> #define I40E_VERIFY_TAG_SHIFT           31
> #define I40E_VERIFY_TAG_MASK            (0x3ULL << I40E_VERIFY_TAG_SHIFT)
>
> The easiest way to verify would be to rewrite the registers for
> flow_type 29, 30, and 31 to match the value that I had shown earlier
> from my dump:
> [  294.687087] i40e 0000:81:00.1: flow_type: 31 input_mask:0x0001801e00000000
>
> I will take a look at putting together a patch that can be tested to
> verify if this is actually the issue tomorrow.
>
> Thanks.
>
> - Alex

So the patch below/attached should resolve the issues you are seeing
with your system in terms of UDPv4 RSS. What you should see with this
patch is the first function to come up will display some "update input
mask" messages, and then the remaining functions shouldn't make any
noise about it since the registers being updated are global to the
device.

If you can test this and see if it resolves the UDPv4 RSS issues I
would appreciate it.

Thanks.

- Alex

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c
b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 65c2b9d2652b..c0a7f66babd9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10998,6 +10998,58 @@ static int i40e_pf_config_rss(struct i40e_pf *pf)
                ((u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(1)) << 32);
        hena |= i40e_pf_get_default_rss_hena(pf);

+       for (ret = 64; ret--;) {
+               u64 hash_inset_orig, hash_inset_update;
+
+               if (!(hena & (1ull << ret)))
+                       continue;
+
+               /* Read initial input set value for flow type */
+               hash_inset_orig = i40e_read_rx_ctl(hw,
I40E_GLQF_HASH_INSET(1, ret));
+               hash_inset_orig <<= 32;
+               hash_inset_orig |= i40e_read_rx_ctl(hw,
I40E_GLQF_HASH_INSET(0, ret));
+
+               /* Copy value so we can compare later */
+               hash_inset_update = hash_inset_orig;
+
+               /* We should be looking at either the entire IPv6 or IPv4
+                * mask being set. If only part of the IPv6 mask is set, but
+                * the IPv4 mask is not then we have a garbage mask value
+                * and need to reset it.
+                */
+               switch (hash_inset_orig & I40E_L3_V6_SRC_MASK) {
+               case I40E_L3_V6_SRC_MASK:
+               case I40E_L3_SRC_MASK:
+               case 0:
+                       break;
+               default:
+                       hash_inset_update &= ~I40E_L3_V6_SRC_MASK;
+                       hash_inset_update |= I40E_L3_SRC_MASK;
+               }
+
+               switch (hash_inset_orig & I40E_L3_V6_DST_MASK) {
+               case I40E_L3_V6_DST_MASK:
+               case I40E_L3_DST_MASK:
+               case 0:
+                       break;
+               default:
+                       hash_inset_update &= ~I40E_L3_V6_DST_MASK;
+                       hash_inset_update |= I40E_L3_DST_MASK;
+               }
+
+               if (hash_inset_update != hash_inset_orig) {
+                       dev_warn(&pf->pdev->dev,
+                                "flow type: %d update input mask
from:0x%016llx, to:0x%016llx\n",
+                                ret,
+                                hash_inset_orig, hash_inset_update);
+                       i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, ret),
+                                         (u32)hash_inset_update);
+                       hash_inset_update >>= 32;
+                       i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, ret),
+                                         (u32)hash_inset_update);
+               }
+       }
+
        i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), (u32)hena);
        i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), (u32)(hena >> 32));

--0000000000009a0fcd0589181114
Content-Type: text/x-patch; charset="US-ASCII"; name="i40e-debug-hash-inputs.patch"
Content-Disposition: attachment; filename="i40e-debug-hash-inputs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvsb12r20>
X-Attachment-Id: f_jvsb12r20

aTQwZTogRGVidWcgaGFzaCBpbnB1dHMKCkZyb206IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVy
LmguZHV5Y2tAbGludXguaW50ZWwuY29tPgoKCi0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaTQwZS9pNDBlX21haW4uYyB8ICAgNTIgKysrKysrKysrKysrKysrKysrKysrKysrKysrCiAx
IGZpbGUgY2hhbmdlZCwgNTIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pNDBlL2k0MGVfbWFpbi5jCmluZGV4IDY1YzJiOWQyNjUyYi4uYzBhN2Y2NmJhYmQ5IDEw
MDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jCisr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMKQEAgLTEwOTk4
LDYgKzEwOTk4LDU4IEBAIHN0YXRpYyBpbnQgaTQwZV9wZl9jb25maWdfcnNzKHN0cnVjdCBpNDBl
X3BmICpwZikKIAkJKCh1NjQpaTQwZV9yZWFkX3J4X2N0bChodywgSTQwRV9QRlFGX0hFTkEoMSkp
IDw8IDMyKTsKIAloZW5hIHw9IGk0MGVfcGZfZ2V0X2RlZmF1bHRfcnNzX2hlbmEocGYpOwogCisJ
Zm9yIChyZXQgPSA2NDsgcmV0LS07KSB7CisJCXU2NCBoYXNoX2luc2V0X29yaWcsIGhhc2hfaW5z
ZXRfdXBkYXRlOworCisJCWlmICghKGhlbmEgJiAoMXVsbCA8PCByZXQpKSkKKwkJCWNvbnRpbnVl
OworCisJCS8qIFJlYWQgaW5pdGlhbCBpbnB1dCBzZXQgdmFsdWUgZm9yIGZsb3cgdHlwZSAqLwor
CQloYXNoX2luc2V0X29yaWcgPSBpNDBlX3JlYWRfcnhfY3RsKGh3LCBJNDBFX0dMUUZfSEFTSF9J
TlNFVCgxLCByZXQpKTsKKwkJaGFzaF9pbnNldF9vcmlnIDw8PSAzMjsKKwkJaGFzaF9pbnNldF9v
cmlnIHw9IGk0MGVfcmVhZF9yeF9jdGwoaHcsIEk0MEVfR0xRRl9IQVNIX0lOU0VUKDAsIHJldCkp
OworCisJCS8qIENvcHkgdmFsdWUgc28gd2UgY2FuIGNvbXBhcmUgbGF0ZXIgKi8KKwkJaGFzaF9p
bnNldF91cGRhdGUgPSBoYXNoX2luc2V0X29yaWc7CisKKwkJLyogV2Ugc2hvdWxkIGJlIGxvb2tp
bmcgYXQgZWl0aGVyIHRoZSBlbnRpcmUgSVB2NiBvciBJUHY0CisJCSAqIG1hc2sgYmVpbmcgc2V0
LiBJZiBvbmx5IHBhcnQgb2YgdGhlIElQdjYgbWFzayBpcyBzZXQsIGJ1dAorCQkgKiB0aGUgSVB2
NCBtYXNrIGlzIG5vdCB0aGVuIHdlIGhhdmUgYSBnYXJiYWdlIG1hc2sgdmFsdWUKKwkJICogYW5k
IG5lZWQgdG8gcmVzZXQgaXQuCisJCSAqLworCQlzd2l0Y2ggKGhhc2hfaW5zZXRfb3JpZyAmIEk0
MEVfTDNfVjZfU1JDX01BU0spIHsKKwkJY2FzZSBJNDBFX0wzX1Y2X1NSQ19NQVNLOgorCQljYXNl
IEk0MEVfTDNfU1JDX01BU0s6CisJCWNhc2UgMDoKKwkJCWJyZWFrOworCQlkZWZhdWx0OgorCQkJ
aGFzaF9pbnNldF91cGRhdGUgJj0gfkk0MEVfTDNfVjZfU1JDX01BU0s7CisJCQloYXNoX2luc2V0
X3VwZGF0ZSB8PSBJNDBFX0wzX1NSQ19NQVNLOworCQl9CisKKwkJc3dpdGNoIChoYXNoX2luc2V0
X29yaWcgJiBJNDBFX0wzX1Y2X0RTVF9NQVNLKSB7CisJCWNhc2UgSTQwRV9MM19WNl9EU1RfTUFT
SzoKKwkJY2FzZSBJNDBFX0wzX0RTVF9NQVNLOgorCQljYXNlIDA6CisJCQlicmVhazsKKwkJZGVm
YXVsdDoKKwkJCWhhc2hfaW5zZXRfdXBkYXRlICY9IH5JNDBFX0wzX1Y2X0RTVF9NQVNLOworCQkJ
aGFzaF9pbnNldF91cGRhdGUgfD0gSTQwRV9MM19EU1RfTUFTSzsKKwkJfQorCisJCWlmIChoYXNo
X2luc2V0X3VwZGF0ZSAhPSBoYXNoX2luc2V0X29yaWcpIHsKKwkJCWRldl93YXJuKCZwZi0+cGRl
di0+ZGV2LAorCQkJCSAiZmxvdyB0eXBlOiAlZCB1cGRhdGUgaW5wdXQgbWFzayBmcm9tOjB4JTAx
NmxseCwgdG86MHglMDE2bGx4XG4iLAorCQkJCSByZXQsCisJCQkJIGhhc2hfaW5zZXRfb3JpZywg
aGFzaF9pbnNldF91cGRhdGUpOworCQkJaTQwZV93cml0ZV9yeF9jdGwoaHcsIEk0MEVfR0xRRl9I
QVNIX0lOU0VUKDAsIHJldCksCisJCQkJCSAgKHUzMiloYXNoX2luc2V0X3VwZGF0ZSk7CisJCQlo
YXNoX2luc2V0X3VwZGF0ZSA+Pj0gMzI7CisJCQlpNDBlX3dyaXRlX3J4X2N0bChodywgSTQwRV9H
TFFGX0hBU0hfSU5TRVQoMSwgcmV0KSwKKwkJCQkJICAodTMyKWhhc2hfaW5zZXRfdXBkYXRlKTsK
KwkJfQorCX0KKwogCWk0MGVfd3JpdGVfcnhfY3RsKGh3LCBJNDBFX1BGUUZfSEVOQSgwKSwgKHUz
MiloZW5hKTsKIAlpNDBlX3dyaXRlX3J4X2N0bChodywgSTQwRV9QRlFGX0hFTkEoMSksICh1MzIp
KGhlbmEgPj4gMzIpKTsKIAo=
--0000000000009a0fcd0589181114--
