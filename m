Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562BC6B9ABC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCNQKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCNQJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:09:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4981314492
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678810197; x=1710346197;
  h=from:to:cc:subject:date:message-id;
  bh=wFV/TQA5QOhFx4q/Z1wBe7FhRjFJ3ABu8l4HV/UyNb4=;
  b=OBzPwKu0GiRQ7VXqO893U0O3rq7tJTjjDu8Qeq665IJb8NhFrMoRsztR
   /cdD7qUZOqIql/6Ti0trwnVWB4Ch7uDNW4C54C2XeRd/kumOzJqDgkHTu
   BTu8jhl5vf2rV2MEZjZr0VzhUrbTTFg+2tErcj7DuWyPAOyUWFwvzBJi9
   14KBtqNG3Xu5Vpaxal5DpmNQywoBBlPKxtlUj+sx5HwzTPvIWhfdhnBAa
   XlDgNHVWQG4jBrXLxmTbnk11aUhYlsMMXfVMGhV8ynK4LkQ5VwQzV9C+4
   /iSEfBIIT4mw5PMtD19gWo+PH4w2bEpHjsmbcfYqZ5DSz/kk6RqgsQZZz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="334956718"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="334956718"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 09:08:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="853260546"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="853260546"
Received: from mmichali-devpc.igk.intel.com ([10.211.235.239])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2023 09:08:22 -0700
From:   Michal Michalik <michal.michalik@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com,
        Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH net] tools: ynl: add the Python requirements.txt file
Date:   Tue, 14 Mar 2023 17:07:58 +0100
Message-Id: <20230314160758.23719-1-michal.michalik@intel.com>
X-Mailer: git-send-email 2.9.5
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a good practice to state explicitely which are the required Python
packages needed in a particular project to run it. The most commonly
used way is to store them in the `requirements.txt` file*.

*URL: https://pip.pypa.io/en/stable/reference/requirements-file-format/

Currently user needs to figure out himself that Python needs `PyYAML`
and `jsonschema` (and theirs requirements) packages to use the tool.
Add the `requirements.txt` for user convenience.

How to use it:
1) (optional) Create and activate empty virtual environment:
  python3.X -m venv venv3X
  source ./venv3X/bin/activate
2) Install all the required packages:
  pip install -r requirements.txt
    or
  python -m pip install -r requirements.txt
3) Run the script!

The `requirements.txt` file was tested for:
* Python 3.6
* Python 3.8
* Python 3.10

Signed-off-by: Michal Michalik <michal.michalik@intel.com>
---
 tools/net/ynl/requirements.txt | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 tools/net/ynl/requirements.txt

diff --git a/tools/net/ynl/requirements.txt b/tools/net/ynl/requirements.txt
new file mode 100644
index 0000000..2ad25d9
--- /dev/null
+++ b/tools/net/ynl/requirements.txt
@@ -0,0 +1,7 @@
+attrs==22.2.0
+importlib-metadata==4.8.3
+jsonschema==4.0.0
+pyrsistent==0.18.0
+PyYAML==6.0
+typing-extensions==4.1.1
+zipp==3.6.0
-- 
2.9.5

base-commit: bcc858689db5f2e5a8d4d6e8bc5bb9736cd80626
