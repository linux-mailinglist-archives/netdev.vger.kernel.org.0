Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D101D0BB9
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 11:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfJIJsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 05:48:23 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:36880 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfJIJsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 05:48:23 -0400
Received: by mail-lj1-f182.google.com with SMTP id l21so1811632lje.4
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 02:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=et8lOmtaNN/+qJZCcz6g4EDV9tX/YzrQGsIk14KQrPU=;
        b=c5B0BqgmCVFPWSuz8Da4ZWwxSE8ws4eTD0U/yS6BHkhGBk/XCVcpNFluH4SW+HkM8z
         0SlFaBzp0UCSkdwdaRC2nSAf718vaGc5s2SXlF5P8IkLFwQTboWWJzye9jB1FMSto6zg
         LOqPWNLdTLGJ088fRBr2SmZVEKCwshfJIVh4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=et8lOmtaNN/+qJZCcz6g4EDV9tX/YzrQGsIk14KQrPU=;
        b=bqiiY/Esrjg/65w1LUqIBFWCdFT92Lh6a0uK/k9gYmetGQpakWgUJbNC8UkZzdfS12
         1icXIZxZf8N2T5KyXlmJY7qVNCWiiBiiijWLA3ryqRWxgWEACf0fEON+HP1InWSZEcgS
         hlcTNmyFr40gxEaKZF4IZffUA3Xke3yRW1Q5QXH3utrFvKzPmZcVNr943Ktbi8EPGZYs
         ot2oWhL5Sok5Mxo8Ceiiurk2yEq31oXb56gJWo3TFRvF2DhBop5qZeQqoKNy1SB7xAxX
         R7fYcBVa/e3t70NGvykOvFQOo2n75ztNgtN1SxT3t8h0HseevTRuPF7I4M0VFU28wgvd
         dI5A==
X-Gm-Message-State: APjAAAW1hizzSe9WdOVzMg83DroJPecon67wwCx2be+ZhbOZqa4FLbys
        GXQ+qnU9K0oBpplvZpFv4H00Wg==
X-Google-Smtp-Source: APXvYqwBkW4Q37wwb1SGFBM0wUnR+L3iv3ig723jgRwMG9+jK2+YkkUND15zVv/X4P1MK3txBNOHmQ==
X-Received: by 2002:a2e:6a04:: with SMTP id f4mr1648215ljc.164.1570614501502;
        Wed, 09 Oct 2019 02:48:21 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i21sm342020lfl.44.2019.10.09.02.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 02:48:21 -0700 (PDT)
References: <20191009094312.15284-1-jakub@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATH bpf-next 1/2] flow_dissector: Allow updating the flow dissector program atomically
In-reply-to: <20191009094312.15284-1-jakub@cloudflare.com>
Date:   Wed, 09 Oct 2019 11:48:20 +0200
Message-ID: <87muea1c7v.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject should say 'PATCH bpf-next', naturally. Sorry for the typo.

-Jakub
