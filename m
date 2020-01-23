Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE1E1472D7
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgAWUuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:50:52 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54439 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbgAWUut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:50:49 -0500
Received: by mail-pj1-f66.google.com with SMTP id kx11so5192pjb.4;
        Thu, 23 Jan 2020 12:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=LjgOxeAcHuTAR9mfPg3Iv4j038oaPMy74hUffI9gyKw=;
        b=ck4h8kipnDWHGzwBzVMxiRBZtIgUqYSE2EFGJPkbalqNGyS2YrZ3zR4CerDbHMbUqy
         B5W+XxMfzk38X0iok+fzx0+KTVfIWIhpykQDVPHAribaUP8jU4f1Vd3l7Dtrv1tEEMhE
         rRcX/yUV1HKTRlAYXAIRsM3riR7GQmmXX8L/48QKNHbp7GADQPXtuI+pznRoprwLQkoM
         eZBdhuNvXswrunRwooxi8Uyepv/QI88C0jAkqjqEX0nuZsClA6qhprVhOWa6yHNU8PIB
         oxFwcAekEn5XCjd9mgjL/gvKVoftbk5c9jQaBHTt43WzBbEd5FlRxbIhHhDt0WBifrLl
         XpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=LjgOxeAcHuTAR9mfPg3Iv4j038oaPMy74hUffI9gyKw=;
        b=Mcqox8+LIPCL2+mDhU0RMbZOKipBgH2exCe+LIhG0bcfen/mPEkkBBrhp7fbmC66g+
         aU39tmji8Ef8imRjeL+tgue0lwPBKDsu1xcbGdCJE3XGn6RCi5y9eWJk+3Atd+gBef1J
         W28kNm/ygKDvERwec9pV3nVOC2Ipa8hsml+Mu8TXbCo6M+sq5YnVS6C4s0MBKyg/e8Sg
         YHiQXDGR1jkmMvdoFR1SAAuVvaNOFYatqstwxVWXk73o4hBXTJko0q+BNZRjUWkEmE7V
         ledR5s1Q3Fi0tzeuKkAjaIoRJ02DqB1vyduzDM9viUgAKIeEzTQA1rP2wD5q7ARaga0i
         h1uA==
X-Gm-Message-State: APjAAAVY2wT9/aHdq0JOn0aD5lHNVxZ4Bnje5z8fltpKsSeul2wcGWra
        b8o3Vkpdc8PvdY4NEM1cpw==
X-Google-Smtp-Source: APXvYqxt3qOd0gS0dU0Yc+4mG4+ntrlFwOGCYSxM8y5vIUtbRkuYWr/BNQCQcRBQEeNQ355b6Or9Ig==
X-Received: by 2002:a17:90a:ac0e:: with SMTP id o14mr6781165pjq.11.1579812648955;
        Thu, 23 Jan 2020 12:50:48 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id a22sm3965618pfk.108.2020.01.23.12.50.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 12:50:48 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH v3] [net]: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Thu, 23 Jan 2020 12:50:47 -0800
Message-Id: <1579812647-830-1-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20200123142929.GV795@breakpoint.cc>
References: <20200123142929.GV795@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian\Daniel,

I raise V4
https://lkml.org/lkml/2020/1/23/797
https://lkml.org/lkml/2020/1/23/798

Let me know if it looks good. Thx.

