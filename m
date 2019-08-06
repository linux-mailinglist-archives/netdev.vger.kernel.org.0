Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B24C829F2
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 05:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfHFDSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 23:18:02 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:39145 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbfHFDSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 23:18:02 -0400
Received: by mail-pf1-f175.google.com with SMTP id f17so36688728pfn.6
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 20:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ATiM9OVjqbAu5K4l6G49RH+1MbLBmOtStQ85uwlzTR0=;
        b=AeeaSs8HPokAlg4LIpm69W8s9xqUjZKpWgtPkuVu4wQeRfxumUN69FbJuhy6wi/1CS
         3/EEnzoBut4opESt/oqaFbQF3u+CrywHCJoqiCVRHIgEVrOg3CUBMaSrYY2XDe5wN7PF
         V0/j61ontdXEI+yevjiLn0Q2eCmQV+xdPZQz4DGUxgL7wLQ2JNVKjQqR2bdQ9ZwUKC4O
         VaC1fVdgYDXqmoNnyGWQRUwidm1FCUBWAtqNDDZg+EuDKZiELG3+dHPADTnOqHe3It+X
         np7sx2TLCENrc45e21cRpDG1PMjz+Iqj6m/GO64jOBKzBC4bpJYwpQOnRaW943w7rO+M
         j6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ATiM9OVjqbAu5K4l6G49RH+1MbLBmOtStQ85uwlzTR0=;
        b=qqd1/+HO76H21IXjgJAHn0NDrDSY2W1lSs32+0oq9QsWQ2yT8qbLrgUhjDqaw6t5v6
         h1ApqRZlUxjWB7qavZda/koHHOooaFupkz/wIQEJuPTAyhPkrwvYRpfRlG8ZYTqETI7V
         1ziAaeUIRmZyZRwrqU+tsDoBGf5AFVnnl1RnnuMQ96dNYOq0oYce9AHARADCXJst80B4
         YO47ZfiPa9y4GV3x08OWZTCLpe//tEwKoFwCLgyjDnJDlQD6qjDBGpvnq+l0TvhN8tIc
         1rny7AaBFqR7UvU1ykVsAV1E2RGx4PnmHnefqZRZCyD8V/dvmtqyVWRGPRuLKg658g50
         ZBiA==
X-Gm-Message-State: APjAAAUMugQdPsBOHbenktrqcd4aS3iHqqIu6P5dfC6RHMrLEaB7P4OO
        neFElJXXiPCoDXa+7UVLyelEMQ==
X-Google-Smtp-Source: APXvYqzmngMM+gxqVSW6JCJCl2w3KIX6euY3Tpv3hgYFyeuPAkpEpIMrIuswZEbI4HUoL1a4aF3mpA==
X-Received: by 2002:a17:90a:c58e:: with SMTP id l14mr893786pjt.104.1565061481357;
        Mon, 05 Aug 2019 20:18:01 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id b36sm24130963pjc.16.2019.08.05.20.18.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:18:01 -0700 (PDT)
Date:   Mon, 5 Aug 2019 20:17:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-04
Message-ID: <20190805201736.7208a2b9@cakuba.netronome.com>
In-Reply-To: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
References: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  4 Aug 2019 04:59:18 -0700, Jeff Kirsher wrote:
> This series contains more updates to fm10k from Jake Keller.
> 
> Jake removes the unnecessary initialization of some variables to help
> resolve static code checker warnings.  Explicitly return success during
> resume, since the value of 'err' is always success.  Fixed a issue with
> incrementing a void pointer, which can produce undefined behavior.  Used
> the __always_unused macro for function templates that are passed as
> parameters in functions, but are not used.  Simplified the code by
> removing an unnecessary macro in determining the value of NON_Q_VECTORS.
> Fixed an issue, using bitwise operations to prevent the low address
> overwriting the high portion of the address.

Looks good. AFAIK void pointer arithmetic is not uncommon in the
kernel, but shouldn't hurt to fix it.

Do you guys have any plans to fix W=1 C=1 build for Intel drivers?
That'd be very nice :)
