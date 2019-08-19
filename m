Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57514927C6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHSO6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:58:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45896 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfHSO6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:58:48 -0400
Received: by mail-qt1-f194.google.com with SMTP id k13so2170616qtm.12;
        Mon, 19 Aug 2019 07:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DDQLg8J2ZT6OKvKU1bcYUqRWaN3frBpAG+iFFbCCH0k=;
        b=UW+iB7a4RqFiR037bwBFYFkseLEPaY13SsJAi8wG4j1MN2t3lIPA6ykij5y2xXVuwG
         mifuvnkD15Ov7lHpGQr/fB54VsJXSBMSnO3o/HMug6KchxWhm+g2LugdCEIEqymlACS1
         nrkOmjq2jZ+LFldbEAoaC50x97IXqKuePUrNTTpIkD/ge4yMWSR0sABYq57Vp48ngmNm
         +GQkGKDp6fex5/plefIR0GwyJG+n5zJPXUrF13B37BDDB1x3IusbPcZnIeuxBecjT2F6
         XvawRUzYkVVr03cUYbn4f4BDA7WijX2+xTn8CU8DJsKLuYYKD4qq0/6ty/xrHedvTxmI
         /PiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DDQLg8J2ZT6OKvKU1bcYUqRWaN3frBpAG+iFFbCCH0k=;
        b=JqqL9wNm0vzE+J7gdAoLwEZmJxcW15mPFVHud4MlbnffnCVR+3kCbvKvPs3LCTxJKc
         jfclOYfx0djXKVnzId3A7TOFTjqF14A8etLD/oj6MFks2PFekArt0yknSy/H6SsT0oV/
         pZDXYdMUo9AbUrvm9fKIAv9D7EOucM+QLySwNef3JZ38CMYT9c3Vd6Fzpc5+cqhBmpxH
         MA3Qp2groHAD533n621bkpt802bpzl3JFzlLZx4rXEEV8x4u9xB4dL7xnpfpqq3+5FHH
         6/0ct14DRXCqMNatrWIvhKz7XexGMePkgeHF9Lk5fHvrhBTRQUIx8WVEUq51KY5kGNei
         U17Q==
X-Gm-Message-State: APjAAAUREvRWCdHmClGlG2tthai5c1DmRi3iViH7ckbIQnSb+qOfLkjY
        qT2z7CtYpY7fAJ1HoE6IGxs=
X-Google-Smtp-Source: APXvYqyIuJ+ZwV+TLiBqeN/XX2ZMr/kcopPENo3aWZqVVz2JME2GG5u9lkMrzNiP6O17v+yDdIEM6Q==
X-Received: by 2002:ac8:7046:: with SMTP id y6mr5815160qtm.131.1566226726992;
        Mon, 19 Aug 2019 07:58:46 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:9612:ee2d:14b6:21a2:1362])
        by smtp.gmail.com with ESMTPSA id o29sm7910509qtf.19.2019.08.19.07.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 07:58:46 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 06D32C1F09; Mon, 19 Aug 2019 11:58:44 -0300 (-03)
Date:   Mon, 19 Aug 2019 11:58:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-ID: <20190819145843.GE2870@localhost.localdomain>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> +static int sctp_setsockopt_asconf_supported(struct sock *sk,
> +					    char __user *optval,
> +					    unsigned int optlen)
> +{
> +	struct sctp_assoc_value params;
> +	struct sctp_association *asoc;
> +	struct sctp_endpoint *ep;
> +	int retval = -EINVAL;
> +
> +	if (optlen != sizeof(params))
> +		goto out;
> +
> +	if (copy_from_user(&params, optval, optlen)) {
> +		retval = -EFAULT;
> +		goto out;
> +	}
> +
> +	asoc = sctp_id2assoc(sk, params.assoc_id);
> +	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
> +	    sctp_style(sk, UDP))
> +		goto out;
> +
> +	ep = sctp_sk(sk)->ep;
> +	ep->asconf_enable = !!params.assoc_value;

Considering this will be negotiated on handshake, shouldn't it deny
changes to Established asocs? (Same for Auth)

> +
> +	if (ep->asconf_enable && ep->auth_enable) {
> +		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
> +		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
> +	}
> +
> +	retval = 0;
> +
> +out:
> +	return retval;
> +}
