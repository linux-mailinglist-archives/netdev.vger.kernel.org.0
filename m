Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DC360BDE
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfGETrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:47:52 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:45035 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfGETrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:47:52 -0400
Received: by mail-qk1-f172.google.com with SMTP id d79so4426343qke.11
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 12:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0TATBqQiMRJ8Xy1OgwvCrtN7E0479qACc1+G8V6M3Xk=;
        b=KJJrjVZMwcVKRVxdXd3Infv2AcoRbbkMqHl48nblHvKb+RQSvlvnn2nVucAzWjDzbM
         UZYjR5U6sWoZVn/oDWqUZz+gC1spDq7q0GnV9fVYAekfBZ2MHaqFz3ZxGWWW/vbfna22
         ikTNUpARfV69f5OoZT8bD4be/Ilu0FTCXZXqxCBNdMximq5q1b7UGs4HUVmnnHpxyQcL
         AOrLZ5uLQdCCHKvXOrFDnLICrwMn1j1ynXGoY2QQimBkDAp6jekWS7Wq5Pfj+KqTRD5Y
         t5QtWQQELNSfGrIR5gpQtlo0jDem4BdVFTZOF2FbfdFbLLWVc/d6PyLQJ/p3ML62Lm5V
         WctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0TATBqQiMRJ8Xy1OgwvCrtN7E0479qACc1+G8V6M3Xk=;
        b=JXohbMTntLhQaWqHP2/bAFu3vGeYRnsdjDmpGpzAl+7+mpKEQ1K6Nj9wUsqsvMia3Z
         eJ0z5y5038ecnCh4UvKykSk9cf4VHqqkIQ+mggqJhldlbGKJNC7DHBlRhX+EYRQwjs9f
         ml3lw8hiOYe5ikJ/ZRf+eb78xE5Yk4MuRfqrKkUv5ZLQloNdIlcgrZAh3Ot8NLAQsVDq
         dzdOND8SxRmnoIdnC66+fZIGQ/AHXczjAESiRenjPdcW3dniC898MkAuTakUgAItxQc9
         h0OQLW8H8EOJtSXPmjuH0c0sm/T5vqFePYhg8FsgbEcEASAgN+vwHoo1utCktmXsZkt1
         cpAQ==
X-Gm-Message-State: APjAAAV3kyttcjid4GezUb8pxDL2xrsvIkvujRwiUZxd+JUX7dyWnq3A
        ZDcZ6uvw2w0pR122WUzQLX1+ew==
X-Google-Smtp-Source: APXvYqzK/GzELHpqDq/VbTWU7XHrEGs37mvjn3uhf5axhCh746s/ZMrQyrHe44GnAj/DAroDaFcBoQ==
X-Received: by 2002:ae9:d606:: with SMTP id r6mr4393361qkk.364.1562356070790;
        Fri, 05 Jul 2019 12:47:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a21sm827074qka.113.2019.07.05.12.47.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 12:47:50 -0700 (PDT)
Date:   Fri, 5 Jul 2019 12:47:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xue Chaojing <xuechaojing@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoshaokai@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: Re: [PATCH net-next] hinic: add fw version query
Message-ID: <20190705124747.67462b22@cakuba.netronome.com>
In-Reply-To: <20190705024028.5768-1-xuechaojing@huawei.com>
References: <20190705024028.5768-1-xuechaojing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jul 2019 02:40:28 +0000, Xue Chaojing wrote:
> This patch adds firmware version query in ethtool -i.
> 
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
