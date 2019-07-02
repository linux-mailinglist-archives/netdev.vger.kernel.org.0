Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353975C8A7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 07:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfGBFQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 01:16:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45640 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBFQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 01:16:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so2585849pgp.12
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 22:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VcgTEp/S6ukzV9iPzNr1VoKiUw6JZrEyKT9FtGp10U8=;
        b=XpxVSNfhZtQHXsJtORQjYuTFzFPJumo/ncXxiDwfg5q6HCCxsk5Pvk3YPRpv+iJM6d
         Te7F74e6xjDeH8cx5Lxt28lZ4K1E5U8hZqg4EPeScWBp2H10q9KC6tJNxNKjnkm84rhW
         4vLZ56NljXRODk1jxlKFzbIj/tWE9AYt4H9nuuDWEO0qlPpXDwOp1OYT0HIrQrfyADfM
         Gw172r7ghqmRC4xH1tmf3JNAgVEZb03+UpnnsgPvajeSsmRFHqGfO0l7qqX13JyUp7cA
         UUMToIvK6L1yER51CyVUloTdsuMO207TsFSgpCqyBwFedWhNh3aIVwVL2aNLt9/Jb+Lr
         t/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VcgTEp/S6ukzV9iPzNr1VoKiUw6JZrEyKT9FtGp10U8=;
        b=ZEl6jcPB2Fyzfv5KbQwfQ0VQUJiaCDaMveHD3dlHG9L0qZhivG8JfsuJ11KQjkPIMb
         6142H6P+HGKh2cT3QK93PHUiztUwk7IKhHpAILGoRkhqsnknkgJm3qf2OkGCACsMEliH
         MBzdJvKVcAACV5h0M7UqTEFEqXyBWJGYKxnY8yx8Jn8j/VWP9f3zI2yN1O5SgxHCG/YR
         VryodwshqY4QTt56xzwUw435lkt4yb1azrdExbgkBwGa7yXlu0u2WGmD3o7uVww/xyn9
         m+BbFHW2i2ysQyIwgw1cALoeJiy95HNkaj60oXu3To4Ki7R/hgNIEsRkjR06dAF7OKvW
         51yw==
X-Gm-Message-State: APjAAAV23zxa2zOHLLEf3fDFizCVAh0lO3Osdpdxe/3x1sYRFIqD1ysS
        YlIrFUtcjzngME2jOcrniLQ=
X-Google-Smtp-Source: APXvYqzzmVpgpb3VEwzmWt0yYkl8/xZjxdrCjFoka7gO/U/kDMxN4hvMJadxyKFq8eEwr/mTJXI5rg==
X-Received: by 2002:a17:90a:950d:: with SMTP id t13mr3347536pjo.81.1562044560838;
        Mon, 01 Jul 2019 22:16:00 -0700 (PDT)
Received: from [172.25.11.16] (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id f10sm10697637pgo.14.2019.07.01.22.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 22:16:00 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2] virtio_net: add XDP meta data support
To:     Jason Wang <jasowang@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
References: <455941f9-aadb-ab70-2745-34f8fd893e89@gmail.com>
 <20190702031542.5096-1-yuya.kusakabe@gmail.com>
 <e703c548-6615-c830-3b8b-ead9346a6bb5@redhat.com>
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=yuya.kusakabe@gmail.com; keydata=
 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 V13X
Message-ID: <32dc2f4e-4f19-4fa5-1d24-17a025a08297@gmail.com>
Date:   Tue, 2 Jul 2019 14:15:55 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e703c548-6615-c830-3b8b-ead9346a6bb5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/19 12:59 PM, Jason Wang wrote:
> 
> On 2019/7/2 上午11:15, Yuya Kusakabe wrote:
>> This adds XDP meta data support to both receive_small() and
>> receive_mergeable().
>>
>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>> ---
>> v2:
>>   - keep copy untouched in page_to_skb().
>>   - preserve the vnet header in receive_small().
>>   - fix indentation.
>> ---
>>   drivers/net/virtio_net.c | 39 +++++++++++++++++++++++++++------------
>>   1 file changed, 27 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 4f3de0ac8b0b..2ebabb08b824 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>                      struct receive_queue *rq,
>>                      struct page *page, unsigned int offset,
>>                      unsigned int len, unsigned int truesize,
>> -                   bool hdr_valid)
>> +                   bool hdr_valid, unsigned int metasize)
>>   {
>>       struct sk_buff *skb;
>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>       else
>>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>   -    if (hdr_valid)
>> +    if (hdr_valid && !metasize)
>>           memcpy(hdr, p, hdr_len);
>>         len -= hdr_len;
>> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>           copy = skb_tailroom(skb);
>>       skb_put_data(skb, p, copy);
>>   +    if (metasize) {
>> +        __skb_pull(skb, metasize);
>> +        skb_metadata_set(skb, metasize);
>> +    }
>> +
>>       len -= copy;
>>       offset += copy;
>>   @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       unsigned int delta = 0;
>>       struct page *xdp_page;
>>       int err;
>> +    unsigned int metasize = 0;
>>         len -= vi->hdr_len;
>>       stats->bytes += len;
>> @@ -683,8 +689,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>             xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>>           xdp.data = xdp.data_hard_start + xdp_headroom;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + len;
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>           orig_data = xdp.data;
>>           act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -695,9 +701,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>               /* Recalculate length in case bpf program changed it */
>>               delta = orig_data - xdp.data;
>>               len = xdp.data_end - xdp.data;
>> +            metasize = xdp.data - xdp.data_meta;
>>               break;
>>           case XDP_TX:
>>               stats->xdp_tx++;
>> +            xdp.data_meta = xdp.data;
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>>                   goto err_xdp;
>> @@ -740,6 +748,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>           memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>>       } /* keep zeroed vnet hdr since packet was changed by bpf */
> 
> 
> I wonder whether or not it's as simple as this. Consider bpf may adjust meta, it looks to me that the vnet header will be overwrite here? If yes, we probably need to have a device specific value then bpf can move the device metadata like vnet header for us?> 
> Thanks

Yes, the vnet header is overwrite by xdp metadata. I'll fix it.

Thanks.

> 
> 
>>   +    if (metasize)
>> +        skb_metadata_set(skb, metasize);
>> +
>>   err:
>>       return skb;
>>   @@ -760,8 +771,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
>>                      struct virtnet_rq_stats *stats)
>>   {
>>       struct page *page = buf;
>> -    struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
>> -                      PAGE_SIZE, true);
>> +    struct sk_buff *skb =
>> +        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>>         stats->bytes += len - vi->hdr_len;
>>       if (unlikely(!skb))
>> @@ -793,6 +804,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>       unsigned int truesize;
>>       unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>>       int err;
>> +    unsigned int metasize = 0;
>>         head_skb = NULL;
>>       stats->bytes += len - vi->hdr_len;
>> @@ -839,8 +851,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           data = page_address(xdp_page) + offset;
>>           xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>>           xdp.data = data + vi->hdr_len;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + (len - vi->hdr_len);
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -852,8 +864,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>                * adjustments. Note other cases do not build an
>>                * skb and avoid using offset
>>                */
>> -            offset = xdp.data -
>> -                    page_address(xdp_page) - vi->hdr_len;
>> +            metasize = xdp.data - xdp.data_meta;
>> +            offset = xdp.data - page_address(xdp_page) -
>> +                 vi->hdr_len - metasize;
>>                 /* recalculate len if xdp.data or xdp.data_end were
>>                * adjusted
>> @@ -863,14 +876,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>               if (unlikely(xdp_page != page)) {
>>                   rcu_read_unlock();
>>                   put_page(page);
>> -                head_skb = page_to_skb(vi, rq, xdp_page,
>> -                               offset, len,
>> -                               PAGE_SIZE, false);
>> +                head_skb = page_to_skb(vi, rq, xdp_page, offset,
>> +                               len, PAGE_SIZE, false,
>> +                               metasize);
>>                   return head_skb;
>>               }
>>               break;
>>           case XDP_TX:
>>               stats->xdp_tx++;
>> +            xdp.data_meta = xdp.data;
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>>                   goto err_xdp;
>> @@ -921,7 +935,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           goto err_skb;
>>       }
>>   -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
>> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>> +                   metasize);
>>       curr_skb = head_skb;
>>         if (unlikely(!curr_skb))
