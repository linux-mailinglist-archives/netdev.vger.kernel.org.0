Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED94736CDAB
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbhD0VF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbhD0VFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 17:05:55 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D197C061574;
        Tue, 27 Apr 2021 14:05:11 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id v13so1682579ilj.8;
        Tue, 27 Apr 2021 14:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1XNQgHOCb1wzAnAA+Ohp1MgYHHZn/RrnDkeXKdJi5CU=;
        b=irnKy6AyWWDfTPJCQ+j0emEg4z7snPfo29BEZ+9JCdoCevIcBkE2TuyeCTyNF1qDjR
         XzC0lqb1pO61HpmvgOih+LpdlU1jYD6Ef9w+b+TVelWtytt58LQhIxaIEVA0eG1SznPc
         OSJ+MqYRCiIVw7rcnHeU01x/sLIKGZwK3OOPXGfdyoLJQHAAhyxvRxa+V7yamOrGAJGy
         ry6JqLhKKuIK+ewtPGYReDDvF5ABPy0bXIwS4VnrhIKA1IkfSHSOuhucmJay2xmoaBup
         h8CnlWXwucqRegh4R2FPlmpoGolu+aFCe2hAsxVWmd3RSHo8RU+AiXxcpRf9ZUZhaC6+
         tHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1XNQgHOCb1wzAnAA+Ohp1MgYHHZn/RrnDkeXKdJi5CU=;
        b=bwuQTREhT0kFtPehbdodKXgMeUaFkx9LjuNEcrzAAlU/GjtJW/uSKaU3YBhN67trS9
         UEvuYd24va4MJRAIIIhBi5qAw0YIfZPCf0vVIJcCaTYR7BUvzCfIheYanw28EM1Rz3To
         HmqaafpFZImVLEkDCH46H7t15qWvtfCJUjWIV2Sou4azpwieW6BECaajscwce2bRZ8OW
         bbFGZpcegVLCdsFh4vMk8+UHNCAC9RL7iF8oMEDWEDcgf73d2dW4tm8l8O/NEDBc34oJ
         7x5q+EiQxFx2H8o0rNFvTcJ50qPS3PrD+c5r3eRxDdc5S02fJB/x2J7jS0SIWBvIQFj6
         CyAg==
X-Gm-Message-State: AOAM531+gwUKTjum/qLwYIspT4v47EfXpl5QRlzqPLK29YhY4sjZOHqR
        sDbA8SgifnD39OAdsRrb25Y=
X-Google-Smtp-Source: ABdhPJwIg6fwksRH/+UOmJYh7D6D6sap0G0egb9e0mYc1fkc03vAlQeoLwqpUaQDp+3RrzHSQTAC9A==
X-Received: by 2002:a92:c78b:: with SMTP id c11mr14624410ilk.249.1619557511019;
        Tue, 27 Apr 2021 14:05:11 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id 11sm1862831ilg.53.2021.04.27.14.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 14:05:10 -0700 (PDT)
Date:   Tue, 27 Apr 2021 14:05:04 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <60887c80a74c2_12319208a0@john-XPS-13-9370.notmuch>
In-Reply-To: <60887b7ba5bba_12319208a5@john-XPS-13-9370.notmuch>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com>
 <60887b7ba5bba_12319208a5@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind()
 helper.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > Add new helper:
> > 
> > long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> > 	Description
> > 		Find given name with given type in BTF pointed to by btf_fd.
> > 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > 	Return
> > 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> 
> I'm missing some high-level concept on how this would be used? Where does btf_fd come
> from and how is it used so that it doesn't break sig-check?

aha as I look through this again it seems btf_fd can be from fd_array[] and
sig-check will pan out as well as BTF can come from any valid file.

Correct? If so lgtm at high-level.
