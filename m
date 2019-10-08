Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E60D02BA
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbfJHVSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:18:45 -0400
Received: from mx2.ucr.edu ([138.23.62.3]:13686 "EHLO mx2.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730781AbfJHVSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 17:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570569524; x=1602105524;
  h=mime-version:from:date:message-id:subject:to;
  bh=7ivXoMVu8s+JtT7SVGYU6lcEvBBmpcUMZbNR5PyOLRg=;
  b=XEIWMYYKKWuTMxX7A/XSHuRdzEveYu+8VLoZhVHz8xD2L44D6dwPUq1I
   nDbVxtJHF36nTuqhHaSFBhQzW+zzhp5lZSETkqv2ud1HonwL9W2J9eIMj
   WmtiXDCyIt92OPspp/MJ/tLcVAR1YBgF73Ux17jH58fUYk/NExKIfD/Fk
   TOSz2rouvAiozPjTfmuj6RITpaAILX7LIhzXXwSWEQW8vPYSEqtelUP7p
   I2bb5oCeV98ZBW3gF7j/gFEwPV4YjnGd0KhUXG0efbFi9Hw+KzPlIPkgy
   y8Urz0Ak4+rdP3H0zyOvRVJ3DKlhHJXD1mLjBGgJq89KgDmDSyi7Q9t2a
   Q==;
IronPort-SDR: ka4ETTKnuyumVWs8c3xAAD9PzFFZBGeT6PKZoNSpUA7RlTvFZZqiL3tavUZ9T2MP2Lkr8YgjYe
 nl5iSOYWl8qCrgj6Ftk5IyCTo7V3KzYdi6RnUA6u45Kw+4XjcZMgTPTxunnwOmMWViQ9k17fix
 tHyM9bvw1asG0bYg7wpBGayc8ctZajgFvz2ybB+w58pjgqvG/wyeqorGotcnCCenG7J4OffJNV
 bvth6wjbiQbTlyi8VZZDmDWX5e9ZGS/S9w/Dtf1dtOaAun5y6Z9476UzqjiSLraCCPoQIRuR0V
 Rhs=
IronPort-PHdr: =?us-ascii?q?9a23=3AlW9gEREWw9xWpFm8wx7xtZ1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ7zrsiwAkXT6L1XgUPTWs2DsrQY0rGQ7vGrADJZqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba58IRmsrQjcssYajZZjJ6os1x?=
 =?us-ascii?q?DEvmZGd+NKyG1yOFmdhQz85sC+/J5i9yRfpfcs/NNeXKv5Yqo1U6VWACwpPG?=
 =?us-ascii?q?4p6sLrswLDTRaU6XsHTmoWiBtIDBPb4xz8Q5z8rzH1tut52CmdIM32UbU5Ui?=
 =?us-ascii?q?ms4qt3VBPljjoMOiUn+2/LlMN/kKNboAqgpxNhxY7UfJqVP+d6cq/EYN8WWX?=
 =?us-ascii?q?ZNUsNXWidcAI2zcpEPAvIOMuhYoYfzpEYAowWiCgS3GOPj1iVFimPq0aEm0e?=
 =?us-ascii?q?ksFxzN0gw6H9IJtXTZtNf6NKYTUOC10anIyijIYPBW2Tjn6YjDbxcsoPGNXL?=
 =?us-ascii?q?Jwa8XRyFUjGx/Lg1iLtIzqIymV2v4TvGeG8uptTOSigHMkpQFpujWj2Nsgh4?=
 =?us-ascii?q?3Tio8Wyl3I7zh1zYc3KNGiSkN3fNipG4ZKuS6ALYt5WMYiTnltuCY917IJp4?=
 =?us-ascii?q?a2fDMPyJQ73x7fbOGHc5SQ7hLjSumRJTB4iWpgeL2lhhay9VGsyunyVsWpyV?=
 =?us-ascii?q?pKoChInsTWunAC0BzT7ceHSv9j8Uu7xTmP0AXT5vlFIUAyi6XbN4YszqAsmp?=
 =?us-ascii?q?cXq0jOHS/7lF/rgKKXdEgo4Oql5/n/brXjvJCcNot0ig/kMqQpn8yyGeQ5Mw?=
 =?us-ascii?q?kOX2eB+OSwyKHv8EPiTbVXkvI2iLPVv47HKsQGvqK5GRNa0p4/6xajCDeryN?=
 =?us-ascii?q?IYkmcbLF1YZh2HkZPkO0/BIP/mF/ezmVesnylxx/DAILLhBo/BLn/ZkLfuLv?=
 =?us-ascii?q?5B7Bt+zwo6y9ZS/Np+B6sOaKbxXU/4strVFTciMhSvxOL6FNR60JhYX2+TVO?=
 =?us-ascii?q?vReo/br16Ertlpa8yNYIsYony1f/Qs+fPrpXMwh1IYea6nwd0RZWzuWrxiIk?=
 =?us-ascii?q?OEcT/zg80MFWoRpSIgQ+Hwzl6PSzheYzC1Ra14rjc2FI6rE6/dSY23xr+Mxi?=
 =?us-ascii?q?G2GttRfG8CQlSNF2r4MoaJQfEBbAqMLcJ71D8JT76sT8kmzx79mhX9zu9WL/?=
 =?us-ascii?q?jU5ypQh5Lq1ZAh9v/TnBBqrWdcEs+HlWyBUjcnzSszWzYq0fUn8gRGwVCZ3P?=
 =?us-ascii?q?092qQAGA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2E8AgCt/Jxdh0enVdFmgkGEEIRNjmK?=
 =?us-ascii?q?FFwGWIoF7AQgBAQEOLwEBhwgjNgcOAgMJAQEFAQEBAQEFBAEBAhABAQEIDQk?=
 =?us-ascii?q?IKYVAgjopAYNVEXwPAiYCJBIBBQEiARoagwCCC6IfgQM8iyaBMohmAQkNgUg?=
 =?us-ascii?q?SeiiMDoIXjDOCWASBOQEBAZUvllcBBgKCEBQDjFGIRRuCKpcWji2ZTw8jgTY?=
 =?us-ascii?q?DgggzGiV/BmeBT08QFIFpjkwkkUQBAQ?=
X-IPAS-Result: =?us-ascii?q?A2E8AgCt/Jxdh0enVdFmgkGEEIRNjmKFFwGWIoF7AQgBA?=
 =?us-ascii?q?QEOLwEBhwgjNgcOAgMJAQEFAQEBAQEFBAEBAhABAQEIDQkIKYVAgjopAYNVE?=
 =?us-ascii?q?XwPAiYCJBIBBQEiARoagwCCC6IfgQM8iyaBMohmAQkNgUgSeiiMDoIXjDOCW?=
 =?us-ascii?q?ASBOQEBAZUvllcBBgKCEBQDjFGIRRuCKpcWji2ZTw8jgTYDgggzGiV/BmeBT?=
 =?us-ascii?q?08QFIFpjkwkkUQBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,272,1566889200"; 
   d="scan'208";a="13729524"
Received: from mail-lf1-f71.google.com ([209.85.167.71])
  by smtp2.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2019 14:18:43 -0700
Received: by mail-lf1-f71.google.com with SMTP id t84so25124lff.10
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BzqX1zVw4wq3Gt+nW+YozxJEWLVjzz1XyMCyK/6yVFo=;
        b=Y5ztIOifN6bE1K1vwR8aHnZeqLxwvRcOKm9xME8RLvvmbfKJMaIZa52MOUiJYMMVBG
         IPnG1LpwW2TU7zbI3D4GYlxGNAXxPxzvENhr7roXyXF/QIygMiGxGOnoI+EpkbpFgsb/
         UDMetDHmStfE/x6sCjAjYiNd1bBWuWPpuNFFAtxfGwP7FGtexxlcRw/We4xlXDFPM3sY
         AvTO2o4UF3w5yWWgAo2CBCzMPHdaN5mVfe52z3s1V4TF9UeRqjM1BfUuimJRQ0KkjqOX
         4j6Le7yMRElD+B55eL3nAjLUh3eIwB9rXTqByIewhZcJtg6ejUqoobuu+AAMHdvEnM+V
         8New==
X-Gm-Message-State: APjAAAUGh1GYJOrg5fkzobJN85vWLBNj8mDbGqJT4RwYp41Hgt35qFTO
        k1LICI5ibs8AGbXM9jbrvqse1+EgK7r/yt4OXXBr+OiECPADphL2hlfyduVRn0xOvJjMB/OW0Of
        I2ynvXv5KLYhtgKwOdxcSkrsZtME6IXf2hQ==
X-Received: by 2002:a2e:634e:: with SMTP id x75mr152651ljb.25.1570569521535;
        Tue, 08 Oct 2019 14:18:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwxdSHEcSfRKYlPljj5Tuv1lx9cKQ4bNLJxj+P06OlnAhwoDIezvXyKWld7+DEaALP61IUuVX5UPYX+YpMFYDk=
X-Received: by 2002:a2e:634e:: with SMTP id x75mr152642ljb.25.1570569521308;
 Tue, 08 Oct 2019 14:18:41 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Tue, 8 Oct 2019 14:19:23 -0700
Message-ID: <CABvMjLQ0Qgzk74yg4quZG4CMKy8pb6pV3XGm_cg4NRkTiCHaKA@mail.gmail.com>
Subject: Potential uninitialized variables in cfg80211
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:
net/wireless/chan.c:
Inside function cfg80211_chandef_compatible(), variable "c1_pri40",
" c2_pri40", "c1_pri80" and "c2_pri80" could be uninitialized if
chandef_primary_freqs() fails. However, they are used later in the if
statement to decide the control flow, which is potentially unsafe.

The patch is hard since we do not know the correct value to initialize them.
-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
