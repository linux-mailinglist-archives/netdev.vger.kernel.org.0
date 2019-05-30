Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8883012B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfE3RpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:45:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40504 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3RpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:45:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so2421641pgm.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XM3GQfAxDAK92gWJtU7kKmNBzAhMtoKEo1rMfKs8kuM=;
        b=nmybHuCYLujkaN4u6O0tMVJK9Z/hDewNeuUqR1YPtsHuFlEVIWp32CgoyHlk3ncVOZ
         ExN0L62Zc7kyT8NSBNyXUf5EPexgkOaxGdP8n9Rj/5O6k40ejeTzrseYRYKdAXZRHybz
         Q5ee1s5yavRsbV5LkDCafaa6QB4cjH9NDTU0+4oP9fQCCmSSXlrG2qC3rjk7DzAodX4/
         1d/ayQ2Hm2DRNeOx0Te5wth8IhjXZwHKWqJcwWJs4SADjJvAWJ6nEBf4WnY9wZuuKGg8
         ElYQg4baj1S2FaGViLd47cKJBBEYgLBWSdmkiNVWC+uo84pl4a3Usd2QE4mMuyum61Zz
         odNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XM3GQfAxDAK92gWJtU7kKmNBzAhMtoKEo1rMfKs8kuM=;
        b=X79B9sGRCoGgFVDlVK1vEFdgiEkvkNWtJAKidvpO652n1k9bY/z5kbydpyQVVI/b0a
         d0i+BiyNgb+mSPNd2wSH9qumHJrUqpiA/nxKh0h4UeRzL1GlbmldSZhj0cNM7sA+SJrX
         ADDURcNEAlUd/zKnqCgMMSYUSogRkDRXEaQv0c3jQaXHtqlurd1V+KcPKLkKetebW75m
         kNL8WI1UDZWAvJxfMkV7NnvHpUOpACcVERJHr2OHubITq+C8z75tO+NemtazNZwVf5Ic
         rFPD5Mz32z2CbngWFXIQz0bfTnVIgPjHq3rckrGDxwalCCV+Tgefe2x2i9gnLAxsIFpB
         3Zug==
X-Gm-Message-State: APjAAAVuvHFMz3vkPemC9aJM1nkHy0Kyr9x8Y16okKG8GaWs7LQPlOYx
        yRmbtMSNl0x6qOkdonQU30/WWA==
X-Google-Smtp-Source: APXvYqzHaig0K7d1MxVjpbasHTsrF9QZw3AQN8F/KapwxRMYCvmZNpTo71OYsGAaSiS38P5Wdg7jgg==
X-Received: by 2002:a17:90a:c701:: with SMTP id o1mr3752762pjt.59.1559238322916;
        Thu, 30 May 2019 10:45:22 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r44sm3167870pjb.13.2019.05.30.10.45.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 10:45:22 -0700 (PDT)
Date:   Thu, 30 May 2019 10:45:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 7/9] Add support for nexthop objects
Message-ID: <20190530104521.3600201f@hermes.lan>
In-Reply-To: <20190530031746.2040-8-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
        <20190530031746.2040-8-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 20:17:44 -0700
David Ahern <dsahern@kernel.org> wrote:

> +static struct
> +{

kernel style is:

static struct {
...
