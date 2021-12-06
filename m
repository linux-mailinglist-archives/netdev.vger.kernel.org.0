Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C307946A295
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhLFRUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbhLFRUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:20:35 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96186C061746;
        Mon,  6 Dec 2021 09:17:06 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id j7so10916033ilk.13;
        Mon, 06 Dec 2021 09:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2dLMEVMKQVYCsMPOCFGWeJOdsdGdbm0cRJ0ilbVq7p4=;
        b=iqg0WeETOVVDjqfr6D96VihLiOo/z669801V6fi56bdxR9ulW55tokdkkmW/xU8O9w
         OIlnd/MZ9teuXNAyIlKIVFsdb+72fi/iWDugBvpV3lJZQzIrc6Uax+7x6NsAR3r9MJJu
         bTWOC4rlllN29kZhkPWJmOlUGI55fT300ezssYv9CsxcbwgmbQvM6wCwZhC8Fy26SCwE
         PosdHb5XUuFMeZw/ZbreFK+bVrdzvfuvaDOAaCjKyPNhbOs16k1zh0PcV1drPSLEMWuz
         zHLiownUBIpqHZrji5vhC871ynsU9x2FEcFrBJtCL2GjlImXArf4k+kAIlqQF7/TS5mZ
         aEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2dLMEVMKQVYCsMPOCFGWeJOdsdGdbm0cRJ0ilbVq7p4=;
        b=K33XDXg9TLh3196vKu1TqmAjN9q8x2JSEQ+0MjXeVVjW8iGOkporC/D54AyQlexuyo
         FOD5LgMDxANrzPcMDi15IXssNU6gu0+KLMIXfMvvK7TUH2Jt6xoR+NzSR83s3jigzNQh
         Crfli2OBc8b+DsHbLh71Leop0cs3B1Hhrz53FBqGxicuw1zligFa1dgOLtu22EKx0ubN
         FYHA4TMlC/L1vI8xGEMk1cbYP0STFkgX61+n+8hFnBCG+T4482nTlDOCSBmhsYnx/+ix
         gXAbumqWomubOEK3nN6fcC0TYGk3VTwtUpAQAcLxNdnRs+W/CpK+cC39Zx34fag2ob5N
         2jHA==
X-Gm-Message-State: AOAM5324SQDXFS9LHDb2DV7rMN4bXuOM4J2lcWvNd1Ii4UgenqyZ1ly9
        LCryubbzSEhBbnmJXiGpRvs=
X-Google-Smtp-Source: ABdhPJy88Vh2c+ndNg7viNo/pgjePcv9v1hGfkXLEhvDbZ+ed/nOypF7wuSijXOaTnRaK6t2VWNREA==
X-Received: by 2002:a05:6e02:1c88:: with SMTP id w8mr34879644ill.318.1638811025904;
        Mon, 06 Dec 2021 09:17:05 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id f10sm7073021ils.13.2021.12.06.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:17:05 -0800 (PST)
Date:   Mon, 06 Dec 2021 09:16:58 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae458a58d73_88182082b@john.notmuch>
In-Reply-To: <Ya4nI6DKPmGOpfMf@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
 <61ad94bde1ea6_50c22081e@john.notmuch>
 <Ya4nI6DKPmGOpfMf@lore-desk>
Subject: Re: [PATCH v19 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > From: Eelco Chaudron <echaudro@redhat.com>
> > > 
> > > This change adds support for tail growing and shrinking for XDP multi-buff.
> > > 
> > > When called on a multi-buffer packet with a grow request, it will work
> > > on the last fragment of the packet. So the maximum grow size is the
> > > last fragments tailroom, i.e. no new buffer will be allocated.
> > > A XDP mb capable driver is expected to set frag_size in xdp_rxq_info data
> > > structure to notify the XDP core the fragment size. frag_size set to 0 is
> > > interpreted by the XDP core as tail growing is not allowed.
> > > Introduce __xdp_rxq_info_reg utility routine to initialize frag_size field.
> > > 
> > > When shrinking, it will work from the last fragment, all the way down to
> > > the base buffer depending on the shrinking size. It's important to mention
> > > that once you shrink down the fragment(s) are freed, so you can not grow
> > > again to the original size.
> > > 
> > > Acked-by: Jakub Kicinski <kuba@kernel.org>
> > > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > > ---

[...]

pasting full function here to help following along.

+
+static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int i, n_frags_free = 0, len_free = 0;
+
+	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
+		return -EINVAL;
+
+	for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
+		skb_frag_t *frag = &sinfo->frags[i];
+		int size = skb_frag_size(frag);
+		int shrink = min_t(int, offset, size);
+
+		len_free += shrink;
+		offset -= shrink;
+
+		if (unlikely(size == shrink)) {
+			struct page *page = skb_frag_page(frag);
+
+			__xdp_return(page_address(page), &xdp->rxq->mem,
+				     false, NULL);
+			n_frags_free++;
+		} else {
+			skb_frag_size_set(frag, size - shrink);
+			break;
+		}
+	}
+	sinfo->nr_frags -= n_frags_free;
+	sinfo->xdp_frags_size -= len_free;
+
+	if (unlikely(offset > 0)) {
+		xdp_buff_clear_mb(xdp);
+		xdp->data_end -= offset;
+	}
+
+	return 0;
+}
+

> > 
> > hmm whats the case for offset to != 0? Seems with initial unlikely
> > check and shrinking while walking backwards through the frags it
> > should be zero? Maybe a comment would help?
> 
> Looking at the code, offset can be > 0 here whenever we reduce the mb frame to
> a legacy frame (so whenever offset will move the boundary into the linear
> area).

But still missing if we need to clear the mb bit or not when we shrink down
to a single frag. I think its fine, but worth double checking. As an example
consider I shrink 2k from a 3k pkt with two frags, one full 2k and another
1k extra,

On the first run through,

 i = 1;
 offset = 2k

+	for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
+		skb_frag_t *frag = &sinfo->frags[i];
+		int size = skb_frag_size(frag);
+		int shrink = min_t(int, offset, size);

shrink = 1k; // min_t(int, offset, size) -> size

+
+		len_free += shrink;
+		offset -= shrink;

offset = 1k

+		if (unlikely(size == shrink)) {
+			struct page *page = skb_frag_page(frag);
+
+			__xdp_return(page_address(page), &xdp->rxq->mem,
+				     false, NULL);
+			n_frags_free++;

Will free the frag

Then next run through

i = 0;
offset = 1k;

+		skb_frag_t *frag = &sinfo->frags[i];
+		int size = skb_frag_size(frag);
+		int shrink = min_t(int, offset, size);

shrink = 1k; // min_t(int, offset, size) -> offset

+
+		len_free += shrink;
+		offset -= shrink;

offset = 0k

+
+		if (unlikely(size == shrink)) { ...
+		} else {
+			skb_frag_size_set(frag, size - shrink);
+			break;
+		}

Then later there is the check 'if (unlikely(offset > 0) { ...}', but that
wont hit this case and we shrunk it back to a single frag. Did we want
to clear the mb in this case? I'm not seeing how it harms things to have
the mb bit set just trying to follow code here.

Would offset > 0 indicate we weren't able to shrink the xdp buff enough
for some reason. Need some coffee perhaps.

Thanks,
John
