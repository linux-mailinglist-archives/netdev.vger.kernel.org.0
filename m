Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378E91030B8
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKTA1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:27:39 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42369 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKTA1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:27:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id n5so25444758ljc.9
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aMKgDpaggrBy00q27TOfhiTrlT1cOxbMLDJvay+wI0A=;
        b=DZ7GryT33VHQQWy8tW8xMwKHHm3ty7dJS/j7N2BCnylJfHK4dyGNsksSp32PZAwOAx
         9pXH8ZmhFdANTcNcBmDg38qRY/FBusN3yJCasSZAUEaGlGy8sTtZU+iunpuf2/qypNKr
         qzR4vNjxRxyqjbnZ8VtNQ2+NR+9E5M1eTK3ysgnjNv1HKlWoBrE4JsPEv5KLUqVDEVOM
         vxsaDr/IBccQa4wfsE7X92g2GhaVoOaHZKLwrsBJUnSjTTzCxOHtwjA4KSagH50A+sUI
         9iFlvMTAQaJd8jtbWBLVqS2bcRy1ss5fhVLeiFQWqlxFmshG7DfzX+npuxQ3WlBKoRIw
         ubxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aMKgDpaggrBy00q27TOfhiTrlT1cOxbMLDJvay+wI0A=;
        b=QzxLsEtsJ8zITR44iTFUEt0c1UKE4PnAqgcPDZQC/0LZeGqOwwLWhr5Nnfi4rl6BKE
         IYETSqYHKi9EZvz9Gi5khYY78raLR1WZwHQk3FoZHurSfvU53X2IdRAshfYnqyu+Nk0l
         UvtoM9GY2J87pT+eax1eZexdpNUMBpmjg6rH5OsIIJSWe3pCYxXBkxiRVmXngx8mUdLa
         5h04xgfggUt/XrFLvgGkcvW57T9C3mJK/HU4iPIdu008XqEspnMlbncRP7mEFb0uY2E7
         2Ksu/LYbjqElbcBkkC71cxodCbWD+ZBhtasJjW6iXizNyhJ2GPzjPj3KFs6f4M96UTj5
         C5YA==
X-Gm-Message-State: APjAAAXD76hQgZe0aK6jteh3ccUGeW1oe1mSuo9rXz3yDgptlpjD9YW1
        uudWmkemjM7NHDnf1GZ58+rSnw==
X-Google-Smtp-Source: APXvYqyfpZyPS5zyuLb9ySEqtM8vx8yniEL3QpZwbubpiWEmbSXVOV6dE/Apyt4AVouxYgr5QE1jMA==
X-Received: by 2002:a2e:974a:: with SMTP id f10mr182041ljj.25.1574209656649;
        Tue, 19 Nov 2019 16:27:36 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p193sm14271665lfa.18.2019.11.19.16.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 16:27:36 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:27:24 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com
Subject: Re: [PATCH net-next 2/4] net: sched: add erspan option support to
 act_tunnel_key
Message-ID: <20191119162724.2ea1d240@cakuba.netronome.com>
In-Reply-To: <a84fb50a28d9a931e641924962eb05e8cfca12bf.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
        <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
        <a84fb50a28d9a931e641924962eb05e8cfca12bf.1574155869.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 17:31:47 +0800, Xin Long wrote:
> @@ -149,6 +159,49 @@ tunnel_key_copy_vxlan_opt(const struct nlattr *nla, void *dst, int dst_len,
>  	return sizeof(struct vxlan_metadata);
>  }
>  
> +static int
> +tunnel_key_copy_erspan_opt(const struct nlattr *nla, void *dst, int dst_len,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
> +	int err;
> +
> +	err = nla_parse_nested(tb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX, nla,
> +			       erspan_opt_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]) {
> +		NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option ver");
> +		return -EINVAL;
> +	}
> +
> +	if (dst) {
> +		struct erspan_metadata *md = dst;
> +
> +		nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER];
> +		md->version = nla_get_u8(nla);
> +
> +		if (md->version == 1 &&
> +		    tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]) {
> +			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX];
> +			md->u.index = nla_get_be32(nla);
> +		} else if (md->version == 2 &&
> +			   tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR] &&
> +			   tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]) {
> +			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR];
> +			md->u.md2.dir = nla_get_u8(nla);
> +			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID];
> +			set_hwid(&md->u.md2, nla_get_u8(nla));
> +		} else {
> +			NL_SET_ERR_MSG(extack, "erspan ver is incorrect or some option is missed");

I think s/missed/missing/

But I think it'd be better if the validation was done also when dst is
not yet allocated. I don't think it matters today, just think it'd be
cleaner.

> +			return -EINVAL;
> +		}
> +	}
> +
> +	return sizeof(struct erspan_metadata);
> +}
> +
>  static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
>  				int dst_len, struct netlink_ext_ack *extack)
>  {
> @@ -190,6 +243,18 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
>  			opts_len += opt_len;
>  			type = TUNNEL_VXLAN_OPT;
>  			break;
> +		case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
> +			if (type) {
> +				NL_SET_ERR_MSG(extack, "Wrong type for erspan options");

Wrong or duplicate, right? If I'm reading this right unlike for Geneve
opts there can be only one instance of opts for other types.

> +				return -EINVAL;
> +			}
> +			opt_len = tunnel_key_copy_erspan_opt(attr, dst,
> +							     dst_len, extack);
> +			if (opt_len < 0)
> +				return opt_len;
> +			opts_len += opt_len;
> +			type = TUNNEL_ERSPAN_OPT;
> +			break;
>  		}
>  	}
>  
