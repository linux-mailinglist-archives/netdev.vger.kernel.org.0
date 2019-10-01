Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E00C40A7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfJATH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:07:27 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:44947 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJATH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:07:26 -0400
Received: by mail-io1-f45.google.com with SMTP id w12so22749624iol.11;
        Tue, 01 Oct 2019 12:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Qa1nIbG+/xD3pQaPUYBBdsqXjXuSE6IPkWs7yI/RsLw=;
        b=LrEFm9OQMGWLtuli6W3o2iKn59FUKsp3Yn2xgSsX1AhVr1IJsaUGqvpX2tvuZHjWnf
         zNJ1pzz2LACE5aqE5pNxp7emEwBO3xvKeTJ/Qs1okbcFgmfXBMgTHyX+UY0jZQWfWe0J
         IoEm0r+CKekyu9nYlW0/bGGF7p5YhMLFvsLdIzlVeE+gSh+jok9ilNZO1o1dsAAoboMy
         9V5SPpK/0T7f943rEEWRyYZD/tyPlCDogWlSMG7gYzgaL3n4P/aAx81ISrAoRgYlF9KC
         Yf7ByysXzwL81L3DWC+NtQ5NIiJyOEoxlWGp6g0hYnCZ3ypXye8bcrm9J4q8F53tWYs9
         CvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Qa1nIbG+/xD3pQaPUYBBdsqXjXuSE6IPkWs7yI/RsLw=;
        b=rCxTt/jV0fbxCr+VwbM98RGULtBNgrr+NZE/5ewCHRvcsLPwTCKcodNbbSqyP/MUeC
         YmGe6fgm75cT5Xc9fUmIRYBJDufyEWS/263841uYKQMqaAaLZEYK5mpJuZRx8yiXsVCG
         AQ9Bkh3FXLBKZv1EZym3lId5wQwsMBhxpYdX/Kfk/B/surTLB0YY9fQrRpEayeqTigDH
         WgqQSShutNtsBpkQZJ692JK5tmDJkzbUGcfl04FTTOJsTDvMkrk1VqEhwRZta65DFurR
         LQBdCDLOfnto8OQ9hzpUT0IIXf1sqibZBqwOHDfaedIzeDy31dFJGJ1kfF7ahZ5VtVlw
         Gc9w==
X-Gm-Message-State: APjAAAWyOrIQHa0a813dVB9JTwe9NKTAtqd2rI0xyh9OanG4QducKmmf
        QfBv53Gf8t/tRuOzyqrB0K0=
X-Google-Smtp-Source: APXvYqxngRzu33utpfGMKS5mVSgt02g3YSoF2XRVcjay3sxPk9HonCmC4YiDVx8aCCTQGkwi44CjLg==
X-Received: by 2002:a92:b68c:: with SMTP id m12mr28804893ill.132.1569956846122;
        Tue, 01 Oct 2019 12:07:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x2sm7216376iob.74.2019.10.01.12.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:07:25 -0700 (PDT)
Date:   Tue, 01 Oct 2019 12:07:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d93a3e4eadb6_85b2b0fc76de5b468@john-XPS-13-9370.notmuch>
In-Reply-To: <20190930185855.4115372-5-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-5-andriin@fb.com>
Subject: RE: [PATCH bpf-next 4/6] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO
 helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add few macros simplifying BCC-like multi-level probe reads, while also
> emitting CO-RE relocations for each read.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
