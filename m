Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E990C1139
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 17:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfI1Pqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 11:46:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38586 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfI1Pqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 11:46:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id x10so5020075pgi.5
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 08:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXNbxmH0klNyeMpr7KHRXvxbawIr5GeyniMwb627yNo=;
        b=N/WG/28SPzeOjcKXIt4YoPPf0k4Hf1Yl9yAfy0vp+HkYax7roMM1FsaNLnzYcSuADg
         bp+PQlv+IJ3b4IOa95F4HRs/eVRCVuiMod/QgsrgeaVq03YGcQ9C3rKwfNbCvPMGRiwt
         sUvDSKdMvttKVyOQ8eq3FOinDN09hneVaXbWYU8tv55dN7gzls3GbjtVN0UC1ZKfcbDU
         LBTeAbYpbjUCThOomOfQAIc9VJpjxg2zrA7ub65MHc9YU3Z/rXyobngx2/v1ITQULvbz
         LNUsnG1euFm5BUG1JdS686c/6MqN914FhWBXeVtq8Q/YPRrJJevPYgwkyEths70QYBR0
         DzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXNbxmH0klNyeMpr7KHRXvxbawIr5GeyniMwb627yNo=;
        b=P9z2JphpRlaZ+CiL6+KsWJh4uQwTL+icQWDOJl+FybUud4IlcKuqbpnMJtawuAQXHW
         dYE5aURKy3KyoyNkqK6SYrIuzplRLoQo7n+Gx2bm4TlY/B7VQQFIa4NWBQIVBU4zQR1c
         7PQIvL1RFRp6IjFEJxZZzZNCFN+bDladHeqaxm4RVW3YVx4HzDUtq3Sp9ksFuLOysTOu
         Pmn4TaowigCd6Yq4WKYoYnZo6HtOib+fEGmfVoxur/Fc5NjzsnVoMXl6dwdWPqcufBZe
         YJWLqdRLgmZLlkJVj1mtUt9rnaT4NGheQDkK0+43vFZQDIpmSh+smn+2DNxv10CtKgOK
         uGaw==
X-Gm-Message-State: APjAAAXi00MZ8MLJN0KPBf+oL+zTu3QjCUGE8JGix9Ylf0qmplqRlrJY
        Ie16gaiIlZ62aMqoQwJRqvaCzw==
X-Google-Smtp-Source: APXvYqx+UghvUIzJ39IUXrXOT1OfehOU9Wajs2soNbgS+6Ih49wgeIFK3Cc0jo0GvCEseV6SKA+ktw==
X-Received: by 2002:aa7:8f33:: with SMTP id y19mr11609420pfr.245.1569685602712;
        Sat, 28 Sep 2019 08:46:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s5sm8071196pjn.24.2019.09.28.08.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 08:46:42 -0700 (PDT)
Date:   Sat, 28 Sep 2019 08:46:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH iproute2 net-next 1/2] bridge: fdb get support
Message-ID: <20190928084641.69233a5a@hermes.lan>
In-Reply-To: <1569646104-358-2-git-send-email-roopa@cumulusnetworks.com>
References: <1569646104-358-1-git-send-email-roopa@cumulusnetworks.com>
        <1569646104-358-2-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Sep 2019 21:48:23 -0700
Roopa Prabhu <roopa@cumulusnetworks.com> wrote:

Overall, looks good.

> +	if (print_fdb(answer, (void *)stdout) < 0) {

Cast to void is not necessary in C (it is in C++)
