Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AD320716A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbgFXKpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:45:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57309 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388421AbgFXKpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:45:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jo2ub-0005Px-7V; Wed, 24 Jun 2020 10:45:49 +0000
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Autocrypt: addr=colin.king@canonical.com; prefer-encrypt=mutual; keydata=
 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
Subject: re: rtw88: pci: define a mask for TX/RX BD indexes
Message-ID: <2d1e070c-d1ee-7f76-f4b2-32668fb9f117@canonical.com>
Date:   Wed, 24 Jun 2020 11:45:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

static analysis with Coverity has detected a out of range write issue on
the assigment rx_ring->buf[i] = skb in rtw_pci_init_rx_ring. The commit
in question is:

commit a5697a65ecd109ce7f8e3661b89a5dffae73b512
Author: Yan-Hsuan Chuang <yhchuang@realtek.com>
Date:   Thu Mar 12 16:08:51 2020 +0800

    rtw88: pci: define a mask for TX/RX BD indexes

Analysis is as follows:


    2. Condition len > 4095UL /* (int)sizeof (struct
rtw_pci_init_rx_ring::[unnamed type]) + (~0UL - (1UL << 0) + 1 & (~0UL
>> 64 - 1 - 11)) */, taking false branch.
    3. cond_at_most: Checking len > 4095UL implies that len may be up to
4095 on the false branch.

267        if (len > TRX_BD_IDX_MASK) {
268                rtw_err(rtwdev, "len %d exceeds maximum RX
entries\n", len);
269                return -EINVAL;
270        }
271
272        head = pci_zalloc_consistent(pdev, ring_sz, &dma);

   4. Condition !head, taking false branch.
273        if (!head) {
274                rtw_err(rtwdev, "failed to allocate rx ring\n");
275                return -ENOMEM;
276        }
277        rx_ring->r.head = head;
278

   5. Condition i < len, taking true branch.
   9. Condition i < len, taking true branch.
   10. cond_at_most: Checking i < len implies that i may be up to 4094
on the true branch.
279        for (i = 0; i < len; i++) {
280                skb = dev_alloc_skb(buf_sz);
   6. Condition !skb, taking false branch.
   11. Condition !skb, taking false branch.
281                if (!skb) {
282                        allocated = i;
283                        ret = -ENOMEM;
284                        goto err_out;
285                }
286
287                memset(skb->data, 0, buf_sz);
   CID (#1 of 1): Out-of-bounds write (OVERRUN)
   12. overrun-local: Overrunning array rx_ring->buf of 512 8-byte
elements at element index 4094 (byte offset 32759) using index i (which
evaluates to 4094).
288                rx_ring->buf[i] = skb;

The rx_ring->buf array is declared in
/drivers/net/wireless/realtek/rtw88/pci.h as:

struct sk_buff *buf[RTK_MAX_RX_DESC_NUM];

where RTK_MAX_RX_DESC_NUM is 512.

There are two places where the length check is incorrect:

rtw_pci_init_tx_ring():

       if (len > TRX_BD_IDX_MASK) {
               rtw_err(rtwdev, "len %d exceeds maximum TX entries\n", len);
               return -EINVAL;
       }

and rtw_pci_init_rx_ring():

       if (len > TRX_BD_IDX_MASK) {
               rtw_err(rtwdev, "len %d exceeds maximum RX entries\n", len);
               return -EINVAL;
       }

The length check should not be against TRX_BD_IDX_MASK but against the
number of elements in rx_ring->buf[].  Also the rx_ring->buf[] is only
512 items. Not sure if one or both of those are errors.

Colin


