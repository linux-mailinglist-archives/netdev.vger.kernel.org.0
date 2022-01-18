Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3509B492774
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbiARNt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbiARNt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 08:49:57 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57798C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 05:49:57 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id p1so36592269uap.9
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CJ6lCw1ijmSGhHPAuPQejDlYTUw2m4SZyRsRBCqRdGw=;
        b=ImrET9Bpngt3HV9En0J/UC56cNTSmjeiFCYsC3NVLHRzdKrQG30Wfn9DcqfmEEpM+w
         BPNaFkLv+c6xzhWVajzq4pdY4w4mvOJmutUGsKL7NwxPXjR1TAkKiZpzGWFBuO/ueg00
         rDQslh/FnrcYNzQB6XA7y2KwUk5LAo33VTyNoEWgEBqYCj2od6WkWEfLwSpuU/K3OXF6
         KA1pvK8v9xCoZ3v+yq4OVtNBCfyvwaVQjTxREiKK5ZgietwJiixgrj/4mjoPxUDCIULU
         a5SGjl2X+bgtOSAhBcnLIqbkNoDLIAo/JhT+3hh6VY+ct+6OtscGi/z+2UouKCytzInT
         LdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=CJ6lCw1ijmSGhHPAuPQejDlYTUw2m4SZyRsRBCqRdGw=;
        b=uhadpnCSyAp2AXKypMZHh4JeK7+yIbfTDcy7gdbD5120QX56hkV7DFFWx5hl7Hqb6K
         p+BGKkryngnbXS8uJk2dm/T2sxlQE9j/modzRoDIxRp5RxbREu6yPCyTKWdtHjrR1Ko/
         6taTb23ccODQPO3amzs2a7h06KpGLl93cbQE8LlkH5WXvGSCldwLwYlsJ04VMKWV8It5
         jcyUQfrCAqfrc4Dk9QiwCrNOlb7xfr70ZjucSusLrCTEM86Sno4y2W0WzOzj3ZhU+4LT
         VRDgr7/aAymqvxGXgqcdsSPzgN6hqpJr+3TbC/m2gqccaU5HTFXgUsNUqwlFZq1/kN9u
         5Umw==
X-Gm-Message-State: AOAM533yjhremqd/EOfx0XK83kxM0SaU4r/n56VUQQq8ApJCIH1dl9Mo
        mztvqmxTERQSfg+6ai2Zo/pqMAvNf/ckaGuTPWk=
X-Google-Smtp-Source: ABdhPJzqdt4Fq6T8K8d4Zk71zDdqbd34kDO9H44ixZt/mtkz3craBTRmr65lqST2pOORWckV6REvul114CP6ZaxFoXY=
X-Received: by 2002:a1f:2186:: with SMTP id h128mr6531564vkh.4.1642513796469;
 Tue, 18 Jan 2022 05:49:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:9b91:0:b0:277:e20e:d0a4 with HTTP; Tue, 18 Jan 2022
 05:49:56 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   orlando moris <barristermusa32@gmail.com>
Date:   Tue, 18 Jan 2022 13:49:56 +0000
Message-ID: <CA+gLmc_BOZOXkK9rd=ET=XizDG4QcveLuXpg32SYFzN1iQJ-uw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGFsbMOzLCB2aW5zYW1sZWdhIHZlcmnDsCB1cHBsw71zdCBhw7Agw75lc3NpIHTDtmx2dXDDs3N0
dXIgc2VtIGtvbSDDrQ0KcMOzc3Row7NsZmnDsCDDvml0dCBlciBla2tpIHZpbGxhIGhlbGR1ciB2
YXIgc8OpcnN0YWtsZWdhIGJlaW50IHRpbCDDvsOtbiB0aWwNCnNrb8OwdW5hci4gw4lnIGVyIG1l
w7AgdGlsbMO2Z3UgdXBwIMOhICgkNy41MDAuMDAwLjAwKSBlZnRpciBsw6F0aW5uDQpza2rDs2xz
dMOmw7BpbmcgbWlubiwgdmVya2Zyw6bDsGluZ2lubiBDYXJsb3Mgc2VtIGJlciBzYW1hIG5hZm4g
b2cgw77Duiwgc2VtDQrDocOwdXIgdmFubiBvZyBiasOzIGjDqXIgw60gTG9tZSBUw7Nnw7MgTMOh
dGlubiB2acOwc2tpcHRhdmludXIgbWlubiBvZw0KZmrDtmxza3lsZGEgbGVudHUgw60gYsOtbHNs
eXNpIHNlbSB0w7NrIGzDrWYgw75laXJyYSAuIMOJZyBoZWYgc2FtYmFuZCB2acOwDQrDvmlnIHNl
bSBuw6FudXN0dSBhw7BzdGFuZGVuZHVyIGhpbnMgbMOhdG5hIHN2byDDvsO6IGfDpnRpciBmZW5n
acOwIGbDqcOwIHZpw7ANCmtyw7ZmdW0uIEVmdGlyIHNrasOzdCB2acOwYnLDtmfDsCDDvsOtbiBt
dW4gw6lnIHVwcGzDvXNhIMO+aWcgdW0gaHZlcm5pZyDDoSBhw7ANCmZhcmENCmZyYW1rdsOmbWQg
w75lc3NhIHPDoXR0bcOhbGEuLCBoYWbDsHUgc2FtYmFuZCB2acOwIG1pZyDDrSDDvmVzc3VtIHTD
tmx2dXDDs3N0dW0NCihvcmxhbmRvbW9yaXM1NkBnbWFpbC5jb20pDQo=
