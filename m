Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5671543EA14
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 23:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhJ1VPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 17:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhJ1VPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 17:15:46 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C52C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 14:13:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m14so7137224pfc.9
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 14:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CV2Ik8AqW14WGgf6I9LX8kCfxG3mdZA2TkfVAyWGvOU=;
        b=JeJ59p5PJFA9ectA08k75wqKYR1thZbbV7p8W2Ai1ASDiqe0sQASG/XgPXl4yuugBC
         qjf7kUNiovSQ7llj3d832VfN/6JxlPJmCGZ2sJwwZiiyaPKcU6gYVSO6XRmncVt08i1F
         I27q3wBkVx9Uf9dl0bN3L4p46gehbEvgwShX30idysZ6kqNt6jLCDi5ABdZR33brM9eW
         X7AAMhfxmysYPdJsdIgKSR8DjNlmBMxW2IbpxqgDwdx3IDF0Zsuc9hAulMv3ZlmqW6/H
         hUfhOswFKRtz6HQbk7Ltv49ysx73qJ891Y01c2kOvdxX2bdZtL2Pd6AOM2Z3zh8kfad5
         CkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CV2Ik8AqW14WGgf6I9LX8kCfxG3mdZA2TkfVAyWGvOU=;
        b=jRJPgJi07AasVTdzpZVBNxnItY6zYInJA8rMOopypwsaOj9ZCobVqEU4WNE2Gpapd5
         iKzE9oy6jxv4HcOGIxsVUt7qmbH/YUlSPw0+AOnk0JV0/YzY15pVj3J96NU+KgJe3WBs
         9LjrJdxNrL/5t4tF6USxjY2dWkGZixWemcd6Fil0xrwYGJpK8J+vnTq7sE4kp4Z/HsRI
         R7PuYv8faFVqeCF8Gthfa1Vkt+H2Y/ty5yTBeRJl5xl+pQNntsJ6jeze9WeIRFZuw9Ux
         bcWWyikkuTSGSzcAggvX42YjcK9yb5/T+wEwcqARLbh8GF/etPe+ZnRU62OwRb1LMlgY
         z9Ug==
X-Gm-Message-State: AOAM530ivQ/UU6uZh27rOepkvahdP7EglKZWKRqqhCMpOGQBOpe/Uozi
        ntkhuFCsPINZ/29mZpLaheEPiQ==
X-Google-Smtp-Source: ABdhPJw99VaGTq1NCrBdya5KIPur4lH8AsEKBJ8cvcJAmttl2PKIt8N8Fm7Vfvp+4syTT23bcY3dmA==
X-Received: by 2002:a63:794b:: with SMTP id u72mr5170216pgc.191.1635455597075;
        Thu, 28 Oct 2021 14:13:17 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id x26sm4314933pff.25.2021.10.28.14.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 14:13:16 -0700 (PDT)
Date:   Thu, 28 Oct 2021 14:13:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 v2 1/2] tc: u32: add support for json output
Message-ID: <20211028141314.652a6142@hermes.local>
In-Reply-To: <b3310b7f38cdcd5a1b2fa14671af16821e895303.1635434027.git.liangwen12year@gmail.com>
References: <cover.1635434027.git.liangwen12year@gmail.com>
        <b3310b7f38cdcd5a1b2fa14671af16821e895303.1635434027.git.liangwen12year@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 11:25:01 -0400
Wen Liang <liangwen12year@gmail.com> wrote:

> +			print_0xhex(PRINT_ANY, "fwmark_value", "\n  mark 0x%04x ", mark->val);
> +			print_0xhex(PRINT_ANY, "fwmark_mask", "0x%04x ", mark->mask);

Use print_nl() which handles oneline mode rather than explicit newline print
